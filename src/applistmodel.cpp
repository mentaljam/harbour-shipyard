#include "applistmodel.h"
#include <shipyard_known_apps.hpp>

#include <QTimer>
#include <QtConcurrentRun>
#include <QStandardPaths>
#include <QDirIterator>
#include <QSettings>
#include <QFileInfo>


qint64 getSize(const QString &path)
{
    qint64 res = 0;
    QFileInfo info(path);
    if (info.isDir())
    {
        QDirIterator it(path, QDir::Files | QDir::Hidden, QDirIterator::Subdirectories);
        while (it.hasNext())
        {
            it.next();
            res += it.fileInfo().size();
        }
    }
    else if (info.isFile())
    {
        res += info.size();
    }
    return res;
}

void processKnownPaths(QStringList &paths, qint64 &size, const QStringList &known_paths)
{
    for (const auto &p : known_paths)
    {
        if (QFileInfo(p).exists())
        {
            paths << p;
            size += getSize(p);
        }
    }
}


AppListModel::AppListModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_busy(false)
    , m_resetting(false)
    , m_process_config(false)
    , m_unused_apps_count(0)
    , m_total_cache_size(0)
    , m_total_config_size(0)
    , m_total_localdata_size(0)
    , m_unused_config_size(0)
    , m_unused_cache_size(0)
    , m_unused_localdata_size(0)
{
    QTimer::singleShot(500, this, &AppListModel::reset);
}

bool AppListModel::busy() const
{
    return m_busy;
}

bool AppListModel::resetting() const
{
    return m_resetting;
}

bool AppListModel::processConfig() const
{
    return m_process_config;
}

void AppListModel::setProcessConfig(bool value)
{
    if(m_process_config != value)
    {
        m_process_config = value;
        emit this->processConfigChanged();
        this->reset();
    }
}

qint64 AppListModel::totalConfigSize() const
{
    return m_total_config_size;
}

qint64 AppListModel::totalCacheSize() const
{
    return m_total_cache_size;
}

qint64 AppListModel::totalLocaldataSize() const
{
    return m_total_localdata_size;
}

int AppListModel::unusedAppsCount() const
{
    return m_unused_apps_count;
}

qint64 AppListModel::unusedConfigSize() const
{
    return m_unused_config_size;
}

qint64 AppListModel::unusedCacheSize() const
{
    return m_unused_cache_size;
}

qint64 AppListModel::unusedLocaldataSize() const
{
    return m_unused_localdata_size;
}

void AppListModel::reset()
{
    QtConcurrent::run(this, &AppListModel::resetImpl);
}

void AppListModel::deleteData(const QString &name, DataTypes types)
{
    QtConcurrent::run(this, &AppListModel::deleteDataImpl, name, types);
}

void AppListModel::deleteUnusedData(DataTypes types)
{
    QtConcurrent::run(this, &AppListModel::deleteUnusedDataImpl, types);
}

void AppListModel::setBusy(bool busy)
{
    m_busy = busy;
    emit this->busyChanged();
}

qint64 AppListModel::removePaths(const QStringList &paths)
{
    for (const auto &p : paths)
    {
        if (p.isEmpty())
        {
            qCritical("One of provided paths is empty");
            return 0;
        }
    }

    qint64 res = 0;
    for (const auto &p : paths)
    {
        auto size = getSize(p);

#ifndef SAFE_MODE
        QFileInfo info(p);
        bool ok = info.isDir()  ? QDir(p).removeRecursively() :
                  info.isFile() ? QFile::remove(p)            : false;

        if (ok)
        {
            qDebug("Deleted %lld bytes '%s'", size, qUtf8Printable(p));
            res += size;
        }
        else
        {
            qWarning("Error deleting '%s'", qUtf8Printable(p));
            emit this->deletionError(p);
        }
#else
        qDebug("SAFE MODE: Deleted %lld bytes '%s'", size, qUtf8Printable(p));
        res += size;
#endif
    }

    return res;
}

QVector<int> AppListModel::clearEntry(CleanerListItem &item, qint64 &deleted, DataTypes types)
{
    QVector<int> changed;

    if (types.testFlag(ConfigData) && item.config_size > 0)
    {
        auto c = removePaths(item.config_paths);
        if (c > 0)
        {
            item.config_size = 0;
            deleted += c;
            changed << ConfigSizeRole;
        }
    }
    if (types.testFlag(CacheData) && item.cache_size > 0)
    {
        auto c = removePaths(item.cache_paths);
        if (c > 0)
        {
            item.cache_size = 0;
            deleted += c;
            changed << CacheSizeRole;
        }
    }
    if (types.testFlag(LocalData) && item.data_size > 0)
    {
        auto c = removePaths(item.data_paths);
        if (c > 0)
        {
            item.data_size = 0;
            deleted += c;
            changed << LocalDataSizeRole;
        }
    }

    return changed;
}

void AppListModel::resetImpl()
{
    this->setBusy(true);
    this->beginResetModel();
    m_resetting = true;
    emit this->resettingChanged();

    m_names.clear();
    m_items.clear();

    // Process known apps
    for (const auto &app : knownApps())
    {
        CleanerListItem item;
        processKnownPaths(item.cache_paths, item.cache_size, app.cache);
        processKnownPaths(item.data_paths, item.data_size, app.local_data);
        if (m_process_config)
        {
            processKnownPaths(item.config_paths, item.config_size, app.config);
        }
        if (item.exists())
        {
            qDebug("Found a known app '%s'", qUtf8Printable(app.name));
            m_names << app.name;
            m_items.insert(app.name, item);
        }
    }

    // Search for other apps
    QStringList filters(QStringLiteral("harbour-*"));
    auto exclude = excludeDirs();
    auto check_excludes = !exclude.pattern().isEmpty();
    QStringList app_paths = {
        QStandardPaths::writableLocation(QStandardPaths::GenericCacheLocation),
        QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)
    };
    if (m_process_config)
    {
        app_paths << QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation);
    }

    auto size = app_paths.size();
    for (int i = 0; i < size; ++i)
    {
        QDirIterator it(app_paths[i], filters, QDir::Dirs | QDir::NoDotAndDotDot);
        while (it.hasNext())
        {
            auto dirpath = it.next();
            // Don't add paths of known apps
            if (check_excludes && exclude.match(dirpath).hasMatch())
            {
                continue;
            }
            auto size = getSize(dirpath);
            auto dirname = it.fileName();
            if (!m_items.contains(dirname))
            {
                qDebug("Found a harbour app '%s'", qUtf8Printable(dirname));
                m_names << dirname;
            }
            auto &item = m_items[dirname];
            switch (i)
            {
            case 0:
                item.cache_paths << dirpath;
                item.cache_size = size;
                break;
            case 1:
                item.data_paths << dirpath;
                item.data_size = size;
                break;
            case 2:
                item.config_paths << dirpath;
                item.config_size = size;
                break;
            default:
                Q_UNREACHABLE();
            }
        }
    }

    QString name_key(QStringLiteral("Desktop Entry/Name"));
    QString icon_key(QStringLiteral("Desktop Entry/Icon"));
    QString desktop_tmpl(QStringLiteral("%1/%2.desktop"));
    QStringList icon_tmpls = {
        QStringLiteral("/usr/share/icons/hicolor/86x86/apps/%1.png"),
        QStringLiteral("/usr/share/themes/sailfish-default/meegotouch/z1.0/icons/%1.png")
    };
    auto desktop_paths = QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation);
    for (const auto &name : m_items.keys())
    {
        for (const auto &path : desktop_paths)
        {
            auto desktop_path = desktop_tmpl.arg(path, name);
            if (QFileInfo(desktop_path).isFile())
            {
                qDebug("'%s' is installed", qUtf8Printable(name));
                auto &item = m_items[name];
                item.installed = true;
                QSettings desktop(desktop_path, QSettings::IniFormat);
                item.title = desktop.value(name_key).toString();
                auto icon_name = desktop.value(icon_key, name).toString();
                for (const auto &tmpl : icon_tmpls)
                {
                    auto icon = tmpl.arg(icon_name);
                    if (QFileInfo(icon).isFile())
                    {
                        item.icon = icon;
                        break;
                    }
                }
                break;
            }
        }
    }

    this->endResetModel();
    this->calculateTotal();
    this->setBusy(false);
    m_resetting = false;
    emit this->resettingChanged();
}

void AppListModel::deleteDataImpl(const QString &name, DataTypes types)
{
    if (!m_items.contains(name))
    {
        qWarning("Model doesn't contain the '%s' entry", qUtf8Printable(name));
        return;
    }
    this->setBusy(true);

    qint64 deleted = 0;
    auto &item = m_items[name];
    auto changed = clearEntry(item, deleted, types);
    int row = m_names.indexOf(name);

    if (!item.exists())
    {
        this->beginRemoveRows(QModelIndex(), row, row);
        m_names.removeOne(name);
        m_items.remove(name);
        this->endRemoveRows();
    }
    else
    {
        auto ind = this->createIndex(row, 0);
        this->dataChanged(ind, ind, changed);
    }

    if (deleted > 0)
    {
        this->calculateTotal();
        emit this->dataDeleted(deleted);
    }
    this->setBusy(false);
}

void AppListModel::deleteUnusedDataImpl(DataTypes types)
{
    this->setBusy(true);

    qint64 deleted = 0;
    auto it = m_items.begin();
    while (it != m_items.end())
    {
        auto &item = it.value();
        if (item.installed)
        {
            ++it;
            continue;
        }

        auto changed = this->clearEntry(item, deleted, types);
        auto &name = it.key();
        int row = m_names.indexOf(name);

        if (!item.exists())
        {
            this->beginRemoveRows(QModelIndex(), row, row);
            m_names.removeOne(name);
            it = m_items.erase(it);
            this->endRemoveRows();
        }
        else
        {
            auto ind = this->createIndex(row, 0);
            this->dataChanged(ind, ind, changed);
            ++it;
        }
    }

    if (deleted > 0)
    {
        this->calculateTotal();
        emit this->dataDeleted(deleted);
    }

    this->setBusy(false);
}

void AppListModel::calculateTotal()
{
    m_unused_apps_count = 0;
    m_total_localdata_size = 0;
    m_total_cache_size = 0;
    m_total_config_size = 0;
    m_unused_config_size = 0;
    m_unused_cache_size = 0;
    m_unused_localdata_size = 0;
    for (const auto &item : m_items)
    {
        m_total_localdata_size += item.config_size;
        m_total_cache_size     += item.cache_size;
        m_total_config_size    += item.data_size;
        if (!item.installed)
        {
            ++m_unused_apps_count;
            m_unused_config_size    += item.config_size;
            m_unused_cache_size     += item.cache_size;
            m_unused_localdata_size += item.data_size;
        }
    }
    emit this->totalChanged();
}

int AppListModel::rowCount(const QModelIndex &parent) const
{
    return !parent.isValid() ? m_names.size() : 0;
}

QVariant AppListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        return QVariant();
    }

    auto &name  = m_names[index.row()];
    auto &item = m_items[name];
    switch (role)
    {
    case NameRole:
        return name;
    case TitleRole:
        return item.title.isEmpty() ? name : item.title;
    case IconRole:
        return item.icon;
    case InstalledRole:
        return item.installed;
    case ConfigSizeRole:
        return item.config_size;
    case CacheSizeRole:
        return item.cache_size;
    case LocalDataSizeRole:
        return item.data_size;
    case SortRole:
        return QString::number(int(!item.installed))
                    .append(item.title.isEmpty() ? name : item.title);
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> AppListModel::roleNames() const
{
    return {
        { NameRole,          "name" },
        { TitleRole,         "title" },
        { IconRole,          "icon" },
        { InstalledRole,     "installed" },
        { ConfigSizeRole,    "configSize" },
        { CacheSizeRole,     "cacheSize" },
        { LocalDataSizeRole, "localDataSize" }
    };
}
