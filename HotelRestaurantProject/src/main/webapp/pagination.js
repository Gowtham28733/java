function paginateRows(tableId, pagerId, perPage) {

    let table = document.getElementById(tableId);
    let pager = document.getElementById(pagerId);

    if (!table || !pager) return;

    let rows = Array.from(
        table.querySelectorAll("tbody tr")
    );

    createPagination(rows, pager, perPage, "");
}

function paginateCards(cardClass, pagerId, perPage) {

    let cards = Array.from(
        document.querySelectorAll(cardClass)
    );

    let pager = document.getElementById(pagerId);

    if (!pager) return;

    createPagination(cards, pager, perPage, "block");
}

function createPagination(items, pager, perPage, showDisplay) {

    let totalPages =
        Math.ceil(items.length / perPage);

    if (totalPages < 2) {
        totalPages = 2;
    }

    function showPage(page) {

        if (page < 1) page = 1;

        if (page > totalPages) {
            page = totalPages;
        }

        let start =
            (page - 1) * perPage;

        let end =
            start + perPage;

        items.forEach(function(item, index) {

            let serialCell =
                item.querySelector(".auto-serial");

            if (serialCell) {
                serialCell.innerHTML = index + 1;
            }

            let orderSerial =
                item.querySelector(".order-serial");

            if (orderSerial) {
                orderSerial.innerHTML = index + 1;
            }

            item.style.display =
                (index >= start && index < end)
                ? showDisplay
                : "none";
        });

        renderButtons(page);
    }

    function addBtn(num, currentPage) {

        if (num < 1 || num > totalPages) return;

        let btn =
            document.createElement("button");

        btn.type = "button";

        btn.innerText = num;

        if (num === currentPage) {
            btn.className = "active-page";
        }

        btn.onclick = function() {
            showPage(num);
        };

        pager.appendChild(btn);
    }

    function addDots() {

        let span =
            document.createElement("span");

        span.innerHTML = "...";

        span.className =
            "pagination-dots";

        pager.appendChild(span);
    }

    function renderButtons(currentPage) {

        pager.innerHTML = "";

        let startPage;

        if (currentPage <= 2) {
            startPage = 1;
        } else {
            startPage = currentPage - 1;
        }

        if (startPage + 2 > totalPages) {
            startPage = totalPages - 2;
        }

        if (startPage < 1) {
            startPage = 1;
        }

        /* FIRST PAGE + DOTS */

        if (startPage > 1) {

            addBtn(1, currentPage);

            addDots();
        }

        /* CENTER BUTTONS */

        addBtn(startPage, currentPage);

        addBtn(startPage + 1, currentPage);

        addBtn(startPage + 2, currentPage);

        /* LAST PAGE + DOTS */

        if (startPage + 2 < totalPages) {

            addDots();

            addBtn(totalPages, currentPage);
        }
    }

    showPage(1);
}