document.addEventListener("DOMContentLoaded", function () {

    setupSwipeFoodPagination();
	
	setupSwipeBox(
	    ".index-services-grid",
	    ".index-service-card",
	    ".service-dots",
	    6
	);

    function setupSwipeFoodPagination() {

        let box =
            document.getElementById("mainCourseBox") ||
            Array.from(document.querySelectorAll(".food-grid"))
                .find(function(g) {
                    return g.id !== "searchResultBox" &&
                           g.querySelector(".food-scroll-item");
                });

        let dotBox = document.querySelector(".food-dots");

        if (!box || !dotBox) return;

        let items = Array.from(box.querySelectorAll(".food-scroll-item"));
        let perPage = 6;
        let currentPage = 1;
        let startX = 0;
        let endX = 0;
        let locked = false;

        let totalPages = Math.ceil(items.length / perPage);
        if (totalPages < 2) totalPages = 2;

        function showPage(page) {
            if (page < 1 || page > totalPages) return;

            currentPage = page;

            let start = (page - 1) * perPage;
            let end = start + perPage;

            items.forEach(function(item, index) {
                item.style.display =
                    index >= start && index < end ? "" : "none";
            });

            updateDots();
        }

        function renderDots() {
            dotBox.innerHTML = "";

            for (let i = 1; i <= totalPages; i++) {
                let dot = document.createElement("span");
                dot.className = "scroll-dot";

                dot.onclick = function() {
                    animatePage(i > currentPage ? "next" : "prev", i);
                };

                dotBox.appendChild(dot);
            }
        }

        function updateDots() {
            dotBox.querySelectorAll(".scroll-dot").forEach(function(dot, index) {
                dot.classList.toggle("active-dot", index + 1 === currentPage);
            });
        }

        function animatePage(direction, targetPage) {

            if (locked) return;
            if (targetPage < 1 || targetPage > totalPages) return;
            if (targetPage === currentPage) return;

            locked = true;

            box.style.transition = "transform 0.55s ease";
            box.style.transform =
                direction === "next"
                    ? "translateX(-80px)"
                    : "translateX(80px)";

            setTimeout(function() {
                showPage(targetPage);

                box.style.transition = "none";
                box.style.transform =
                    direction === "next"
                        ? "translateX(80px)"
                        : "translateX(-80px)";

                setTimeout(function() {
                    box.style.transition = "transform 0.55s ease";
                    box.style.transform = "translateX(0)";
                }, 40);

                setTimeout(function() {
                    locked = false;
                }, 650);

            }, 300);
        }

        function nextPage() {
            animatePage("next", currentPage + 1);
        }

        function prevPage() {
            animatePage("prev", currentPage - 1);
        }

        box.addEventListener("pointerdown", function(e) {
            startX = e.clientX;
        });

        box.addEventListener("pointerup", function(e) {
            endX = e.clientX;
            handleSwipe();
        });

        box.addEventListener("touchstart", function(e) {
            startX = e.touches[0].clientX;
        }, { passive: true });

        box.addEventListener("touchend", function(e) {
            endX = e.changedTouches[0].clientX;
            handleSwipe();
        }, { passive: true });

        function handleSwipe() {

            let diff = startX - endX;

            if (Math.abs(diff) < 130) return;

            if (diff > 0) {
                nextPage();   // right to left = next page
            } else {
                prevPage();   // left to right = previous page
            }
        }

        window.addEventListener("wheel", function(e) {

            let searchBox = document.getElementById("searchResultBox");

            if (searchBox && searchBox.style.display !== "none") return;

            if (Math.abs(e.deltaX) < 40) return;

            if (e.deltaX > 0) {
                nextPage();
            } else {
                prevPage();
            }

        }, { passive: true });

        renderDots();
        showPage(1);
    }
});


function setupSwipeBox(boxSelector, itemSelector, dotSelector, perPage) {

    let box = document.querySelector(boxSelector);
    let dotBox = document.querySelector(dotSelector);

    if (!box || !dotBox) return;

    let items = Array.from(box.querySelectorAll(itemSelector));

    let currentPage = 1;
    let startX = 0;
    let endX = 0;
    let locked = false;

    let totalPages = Math.ceil(items.length / perPage);

    if (totalPages < 2) {
        totalPages = 2;
    }

    function showPage(page) {

        if (page < 1 || page > totalPages) return;

        currentPage = page;

        let start = (page - 1) * perPage;
        let end = start + perPage;

        items.forEach(function(item, index) {

            item.style.display =
                index >= start && index < end
                    ? ""
                    : "none";
        });

        updateDots();
    }

    function renderDots() {

        dotBox.innerHTML = "";

        for (let i = 1; i <= totalPages; i++) {

            let dot = document.createElement("span");

            dot.className = "scroll-dot";

            dot.onclick = function() {
                animatePage(i);
            };

            dotBox.appendChild(dot);
        }
    }

    function updateDots() {

        dotBox.querySelectorAll(".scroll-dot")
            .forEach(function(dot, index) {

                dot.classList.toggle(
                    "active-dot",
                    index + 1 === currentPage
                );
            });
    }

    function animatePage(targetPage) {

        if (locked) return;

        if (targetPage < 1 || targetPage > totalPages) return;

        if (targetPage === currentPage) return;

        locked = true;

        let direction =
            targetPage > currentPage
                ? "next"
                : "prev";

        box.style.transition =
            "transform 0.55s ease";

        box.style.transform =
            direction === "next"
                ? "translateX(-80px)"
                : "translateX(80px)";

        setTimeout(function() {

            showPage(targetPage);

            box.style.transition = "none";

            box.style.transform =
                direction === "next"
                    ? "translateX(80px)"
                    : "translateX(-80px)";

            setTimeout(function() {

                box.style.transition =
                    "transform 0.55s ease";

                box.style.transform =
                    "translateX(0)";

            }, 40);

            setTimeout(function() {
                locked = false;
            }, 650);

        }, 300);
    }

    box.addEventListener("pointerdown", function(e) {
        startX = e.clientX;
    });

    box.addEventListener("pointerup", function(e) {

        endX = e.clientX;

        let diff = startX - endX;

        if (Math.abs(diff) < 130) return;

        if (diff > 0) {

            animatePage(currentPage + 1);

        } else {

            animatePage(currentPage - 1);
        }
    });

    renderDots();
    showPage(1);
}