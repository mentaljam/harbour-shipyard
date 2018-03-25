#ifndef PROXYMODEL_H
#define PROXYMODEL_H

#include <QSortFilterProxyModel>


class ProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit ProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void sort(Qt::SortOrder order = Qt::AscendingOrder);
};

#endif // PROXYMODEL_H
