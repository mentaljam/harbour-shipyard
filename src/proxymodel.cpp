#include "proxymodel.h"


ProxyModel::ProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{}

void ProxyModel::sort(Qt::SortOrder order)
{
    QSortFilterProxyModel::sort(0, order);
}
