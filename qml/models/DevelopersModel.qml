import QtQuick 2.0


ListModel {

    ListElement {
        name: "Petr Tsymbarovich"
        //% "Project maintenance."
        role: qsTrId("hsy-role-mentaljam")
        link: "https://github.com/mentaljam"
        donation: [
            ListElement {
                name: "PayPal"
                icon: "icon-m-paypal.png"
                link: "https://www.paypal.me/osetr"
            },
            ListElement {
                name: "Yandex.Money"
                icon: "icon-m-yandex-money.png"
                link: "https://money.yandex.ru/to/410012535782304"
            }
        ]
    }

    ListElement {
        name: "Greg Goncharov"
        //% "Application icons."
        role: qsTrId("hsy-role-gregguh")
        link: "https://github.com/gregguh"
        donation: [
            ListElement {
                name: "PayPal"
                icon: "icon-m-paypal.png"
                link: "https://paypal.me/gregguh"
            },
            ListElement {
                name: "Rocketbank"
                icon: "icon-m-rocketbank.png"
                link: "https://rocketbank.ru/grigoriy-goncharov-floral-moon"
            }
        ]
    }
}
