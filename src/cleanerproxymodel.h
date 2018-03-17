#ifndef CLEANERPROXYMODEL_H
#define CLEANERPROXYMODEL_H

#include <QSortFilterProxyModel>


class CleanerProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit CleanerProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void sort(Qt::SortOrder order = Qt::AscendingOrder);
};

#endif // CLEANERPROXYMODEL_H
