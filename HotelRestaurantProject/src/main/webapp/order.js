let cart = JSON.parse(localStorage.getItem("cart")) || [];

function saveCart() {

    localStorage.setItem(
        "cart",
        JSON.stringify(cart)
    );
}

function showToast(message) {

    let toast =
        document.getElementById("cartToast");

    if (!toast) {

        toast =
            document.createElement("div");

        toast.id = "cartToast";

        toast.className = "cart-toast";

        document.body.appendChild(toast);
    }

    toast.innerText = message;

    toast.classList.add("show");

    setTimeout(function () {

        toast.classList.remove("show");

    }, 1800);
}

function updateCartCount() {

    cart =
        JSON.parse(localStorage.getItem("cart")) || [];

    let countBox =
        document.getElementById("cartCount");

    if (!countBox) return;

    let totalQty = 0;

    cart.forEach(function (item) {

        totalQty += Number(item.qty);
    });

    countBox.innerText = totalQty;
}

function addToCart(name, price, qtyId) {

    cart =
        JSON.parse(localStorage.getItem("cart")) || [];

    let qtyInput =
        document.getElementById(qtyId);

    if (!qtyInput) {
        return;
    }

    let qty =
        Number(qtyInput.value);

    let maxStock =
        Number(qtyInput.getAttribute("max"));

    if (qty <= 0 || isNaN(qty)) {

        qty = 1;

        qtyInput.value = 1;
    }

    if (maxStock > 0 && qty > maxStock) {

        qtyInput.value = maxStock;

        showToast(
            "Only " + maxStock + " quantity available"
        );

        return;
    }

    price = Number(price);

    let existingItem = cart.find(function (item) {

        return item.name === name;
    });

    if (existingItem) {

        let newQty =
            Number(existingItem.qty) + qty;

        if (maxStock > 0 && newQty > maxStock) {

            showToast(
                "Stock limit reached. Available: " +
                maxStock
            );

            return;
        }

        existingItem.qty = newQty;

        existingItem.stockQty = maxStock;

    } else {

        cart.push({

            name: name,

            price: price,

            qty: qty,

            stockQty: maxStock
        });
    }

    saveCart();

    updateCartCount();

    showToast(name + " added to cart ✔");
}

function increaseQty(qtyId) {

    let qtyInput =
        document.getElementById(qtyId);

    if (!qtyInput) return;

    let currentQty =
        Number(qtyInput.value);

    let maxStock =
        Number(qtyInput.getAttribute("max"));

    if (isNaN(currentQty) || currentQty < 1) {

        currentQty = 1;
    }

    if (maxStock > 0 && currentQty >= maxStock) {

        qtyInput.value = maxStock;

        showToast(
            "Only " + maxStock + " quantity available"
        );

        return;
    }

    qtyInput.value = currentQty + 1;
}

function decreaseQty(qtyId) {

    let qtyInput =
        document.getElementById(qtyId);

    if (!qtyInput) return;

    let currentQty =
        Number(qtyInput.value);

    if (isNaN(currentQty) || currentQty <= 1) {

        qtyInput.value = 1;

        return;
    }

    qtyInput.value = currentQty - 1;
}

function loadBill() {

    cart =
        JSON.parse(localStorage.getItem("cart")) || [];

    let billBody =
        document.getElementById("billBody");

    let grandTotalBox =
        document.getElementById("grandTotal");

    if (!billBody || !grandTotalBox) return;

    billBody.innerHTML = "";

    let grandTotal = 0;

    if (cart.length === 0) {

        billBody.innerHTML =

            "<tr>" +
            "<td colspan='5'>" +
            "Cart is empty" +
            "</td>" +
            "</tr>";

        grandTotalBox.innerText = "Total: ₹0";

        return;
    }

    cart.forEach(function (item, index) {

        let itemTotal =
            Number(item.price) *
            Number(item.qty);

        grandTotal += itemTotal;

        billBody.innerHTML +=

            "<tr>" +

            "<td>" +
            item.name +
            "</td>" +

            "<td>₹" +
            item.price +
            "</td>" +

            "<td>" +
            item.qty +
            "</td>" +

            "<td>₹" +
            itemTotal +
            "</td>" +

            "<td>" +

            "<button " +
            "type='button' " +
            "class='remove-bill-btn' " +
            "onclick='removeBillItem(" + index + ")'>" +

            "Remove" +

            "</button>" +

            "</td>" +

            "</tr>";
    });

    grandTotalBox.innerText =
        "Total: ₹" + grandTotal;
}

function removeBillItem(index) {

    cart =
        JSON.parse(localStorage.getItem("cart")) || [];

    cart.splice(index, 1);

    saveCart();

    loadBill();

    updateCartCount();
}

function showPaymentBox() {

    let method =
        document.getElementById("paymentMethod").value;

    let qrBox =
        document.getElementById("qrPaymentBox");

    let cardBox =
        document.getElementById("cardPaymentBox");

    if (qrBox) {
        qrBox.style.display = "none";
    }

    if (cardBox) {
        cardBox.style.display = "none";
    }

    let upi =
        document.getElementById("upiTransactionId");

    let cardName =
        document.getElementById("cardName");

    let cardNumber =
        document.getElementById("cardNumber");

    let expiryDate =
        document.getElementById("expiryDate");

    let cvv =
        document.getElementById("cvv");

    if (upi) upi.required = false;

    if (cardName) cardName.required = false;

    if (cardNumber) cardNumber.required = false;

    if (expiryDate) expiryDate.required = false;

    if (cvv) cvv.required = false;

    if (method === "QR Payment") {

        if (qrBox) {
            qrBox.style.display = "block";
        }

        if (upi) {
            upi.required = true;
        }
    }

    if (method === "Card") {

        if (cardBox) {
            cardBox.style.display = "block";
        }

        if (cardName) cardName.required = true;

        if (cardNumber) cardNumber.required = true;

        if (expiryDate) expiryDate.required = true;

        if (cvv) cvv.required = true;
    }
}

function prepareOrderData() {

    cart =
        JSON.parse(localStorage.getItem("cart")) || [];

    if (cart.length === 0) {

        alert(
            "Cart is empty. Please add food first."
        );

        return false;
    }

    let paymentMethod =
        document.getElementById("paymentMethod").value;

    if (paymentMethod === "") {

        alert("Please select payment method.");

        return false;
    }

    document.getElementById("cartData").value =
        JSON.stringify(cart);

    return true;
}

function clearCart() {

    localStorage.removeItem("cart");

    cart = [];

    loadBill();

    updateCartCount();
}

function goPayment(contextPath) {

    cart =
        JSON.parse(localStorage.getItem("cart")) || [];

    if (cart.length === 0) {

        return false;
    }

    window.location.href =
        contextPath + "/payment.jsp";
}

document.addEventListener(
    "DOMContentLoaded",
    function () {

        updateCartCount();

        if (
            document.getElementById("billBody")
        ) {

            loadBill();
        }
    }
);