#include "shipyard.h"

#include <QSettings>
#include <QMetaEnum>


Shipyard::Shipyard(QObject *parent)
    : QObject(parent)
    , m_settings(new QSettings(this))
{
    QString key(QStringLiteral("Launches"));
    auto current = m_settings->value(key, 0).toUInt();
    if (current < 10)
    {
        m_settings->setValue(key, current + 1);
    }
    QString oldkey(QStringLiteral("TotalCleared"));
    if (m_settings->contains(oldkey))
    {
        m_settings->setValue(QStringLiteral("TotalDeleted"), m_settings->value(oldkey));
        m_settings->remove(oldkey);
    }
}

bool Shipyard::showBanner() const
{
    if (m_settings->value(QStringLiteral("BannerSeen"), false).toBool())
    {
        return false;
    }

    auto deleted  = this->totalDeletedData();
    auto launches = m_settings->value(QStringLiteral("Launches"), 0).toUInt();

    // 52428800 == 50 MB
    return deleted > 52428800 && launches >= 10;
}

void Shipyard::setBannerShowed()
{
    m_settings->setValue(QStringLiteral("BannerSeen"), true);
}

bool Shipyard::showHint(const Hint &hint) const
{
    auto me = QMetaEnum::fromType<Hint>();
    auto name = me.valueToKey(hint);
    Q_ASSERT(name);
    return !m_settings->value(QStringLiteral("Hints/").append(name), false).toBool();
}

void Shipyard::setHintShowed(const Hint &hint)
{
    auto me = QMetaEnum::fromType<Hint>();
    auto name = me.valueToKey(hint);
    Q_ASSERT(name);
    m_settings->setValue(QStringLiteral("Hints/").append(name), true);
}

qint64 Shipyard::totalDeletedData() const
{
    return m_settings->value(QStringLiteral("TotalDeleted"), 0).toLongLong();
}

void Shipyard::addDeletedData(const qint64 &size)
{
    QString key(QStringLiteral("TotalDeleted"));
    auto current = m_settings->value(key, 0).toLongLong();
    m_settings->setValue(key, current + size);
    emit this->totalDeletedDataChanged();
}

void Shipyard::resetDeletedData()
{
    qDebug("Resetting TotalDeleted value");
    m_settings->remove(QStringLiteral("TotalDeleted"));
    emit this->totalDeletedDataChanged();
}

bool Shipyard::advancedOptionsEnabled() const
{
    return m_settings->value(QStringLiteral("AdvancedOptionsEnabled")).toBool();
}

void Shipyard::setAdvancedOptionsEnabled(bool value)
{
    QString key(QStringLiteral("AdvancedOptionsEnabled"));
    if (m_settings->value(key).toBool() != value)
    {
        m_settings->setValue(key, value);
        emit this->advancedOptionsEnabledChanged();
        if (!value)
        {
            this->setProcessConfigEnabled(false);
            this->setDeleteAllDataAllowed(false);
        }
    }
}

bool Shipyard::processConfigEnabled() const
{
    return m_settings->value(QStringLiteral("ProcessConfigEnabled")).toBool();
}

void Shipyard::setProcessConfigEnabled(bool value)
{
    QString key(QStringLiteral("ProcessConfigEnabled"));
    if (m_settings->value(key).toBool() != value)
    {
        m_settings->setValue(key, value);
        emit this->processConfigEnabledChanged();
    }
}

bool Shipyard::deleteAllDataAllowed() const
{
    return m_settings->value(QStringLiteral("DeleteAllDataAllowed")).toBool();
}

void Shipyard::setDeleteAllDataAllowed(bool value)
{
    QString key(QStringLiteral("DeleteAllDataAllowed"));
    if (m_settings->value(key).toBool() != value)
    {
        m_settings->setValue(key, value);
        emit this->deleteAllDataAllowedChanged();
    }
}
