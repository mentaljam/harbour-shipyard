#include "cleanerproxymodel.h"
#include "cleanerlistmodel.h"


CleanerProxyModel::CleanerProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{}

void CleanerProxyModel::sort(Qt::SortOrder order)
{
    QSortFilterProxyModel::sort(0, order);
}
