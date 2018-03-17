#ifndef CLEANERLISTITEM_H
#define CLEANERLISTITEM_H


#include <QStringList>

struct CleanerListItem
{
    CleanerListItem()
        : installed(false)
        , config_size(0)
        , cache_size(0)
        , data_size(0)
    {}

    inline bool exists()
    { return config_size + cache_size + data_size > 0;}

    bool installed;
    qint64 config_size;
    qint64 cache_size;
    qint64 data_size;
    QString title;
    QString icon;
    QStringList config_paths;
    QStringList cache_paths;
    QStringList data_paths;
};

#endif // CLEANERLISTITEM_H
