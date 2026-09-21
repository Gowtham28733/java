window.addEventListener("load", function () {
    setTimeout(function () {
        const loader = document.getElementById("loader");
        if (loader) {
            loader.style.opacity = "0";
            loader.style.visibility = "hidden";
        }
    }, 800);
});

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("a").forEach(function (link) {
        link.addEventListener("click", function (e) {
            const href = this.getAttribute("href");

            if (
                href &&
                !href.startsWith("#") &&
                !href.startsWith("javascript") &&
                !this.hasAttribute("target")
            ) {
                e.preventDefault();

                const loader = document.getElementById("loader");
                if (loader) {
                    loader.style.opacity = "1";
                    loader.style.visibility = "visible";
                }

                setTimeout(function () {
                    window.location.href = href;
                }, 500);
            }
        });
    });
});