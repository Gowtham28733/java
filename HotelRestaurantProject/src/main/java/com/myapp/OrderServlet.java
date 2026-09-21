package com.myapp;

import java.io.IOException;
import java.sql.*;

import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/placeOrder")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Connection con = null;

        try {
            int branchId = Integer.parseInt(request.getParameter("branchId"));

            String customerName = request.getParameter("customerName");
            String phone = request.getParameter("phone");
            String paymentMethod = request.getParameter("paymentMethod");
            String cartData = request.getParameter("cartData");

            String upiTransactionId = request.getParameter("upiTransactionId");
            String cardNumber = request.getParameter("cardNumber");

            String transactionId = null;
            String cardLast4 = null;

            if ("QR Payment".equals(paymentMethod)) {
                transactionId = upiTransactionId;
            }

            if ("Card".equals(paymentMethod)
                    && cardNumber != null
                    && cardNumber.replace(" ", "").length() >= 4) {

                String cleanCard = cardNumber.replace(" ", "");
                cardLast4 = cleanCard.substring(cleanCard.length() - 4);
            }

            if (cartData == null || cartData.trim().equals("")) {
                response.getWriter().println("Invalid order data: cart is empty");
                return;
            }

            JSONArray cartArray = new JSONArray(cartData);

            double grandTotal = 0;

            for (int i = 0; i < cartArray.length(); i++) {
                JSONObject item = cartArray.getJSONObject(i);

                double price = item.getDouble("price");
                int qty = item.getInt("qty");

                grandTotal += price * qty;
            }

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement orderPs = con.prepareStatement(
                "INSERT INTO orders " +
                "(branch_id, customer_name, phone, payment_method, payment_status, order_status, grand_total, transaction_id, card_last4, order_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())",
                Statement.RETURN_GENERATED_KEYS
            );

            orderPs.setInt(1, branchId);
            orderPs.setString(2, customerName);
            orderPs.setString(3, phone);
            orderPs.setString(4, paymentMethod);
            orderPs.setString(5, "Paid");
            orderPs.setString(6, "Order Placed");
            orderPs.setDouble(7, grandTotal);
            orderPs.setString(8, transactionId);
            orderPs.setString(9, cardLast4);

            orderPs.executeUpdate();

            ResultSet keys = orderPs.getGeneratedKeys();

            int orderId = 0;

            if (keys.next()) {
                orderId = keys.getInt(1);
            }

            PreparedStatement itemPs = con.prepareStatement(
                "INSERT INTO order_items(order_id, item_name, price, qty, total) VALUES (?, ?, ?, ?, ?)"
            );

            for (int i = 0; i < cartArray.length(); i++) {
                JSONObject item = cartArray.getJSONObject(i);

                String itemName = item.getString("name");
                double price = item.getDouble("price");
                int qty = item.getInt("qty");
                double total = price * qty;

                PreparedStatement stockPs = con.prepareStatement(
                    "SELECT stock_qty FROM foods WHERE name=? AND branch_id=? FOR UPDATE"
                );

                stockPs.setString(1, itemName);
                stockPs.setInt(2, branchId);

                ResultSet stockRs = stockPs.executeQuery();

                if (!stockRs.next()) {
                    throw new Exception(itemName + " not found in selected branch");
                }

                int availableStock = stockRs.getInt("stock_qty");

                if (availableStock <= 0) {
                    throw new Exception(itemName + " is out of stock");
                }

                if (availableStock < qty) {
                    throw new Exception(itemName + " only " + availableStock + " quantity available");
                }

                PreparedStatement updateStockPs = con.prepareStatement(
                    "UPDATE foods SET stock_qty = stock_qty - ? WHERE name=? AND branch_id=?"
                );

                updateStockPs.setInt(1, qty);
                updateStockPs.setString(2, itemName);
                updateStockPs.setInt(3, branchId);
                updateStockPs.executeUpdate();

                stockRs.close();
                stockPs.close();
                updateStockPs.close();

                itemPs.setInt(1, orderId);
                itemPs.setString(2, itemName);
                itemPs.setDouble(3, price);
                itemPs.setInt(4, qty);
                itemPs.setDouble(5, total);

                itemPs.addBatch();
            }

            itemPs.executeBatch();

            PreparedStatement payPs = con.prepareStatement(
                "INSERT INTO payment_logs(order_id, payment_method, transaction_id, payment_status, paid_amount) VALUES (?, ?, ?, ?, ?)"
            );

            payPs.setInt(1, orderId);
            payPs.setString(2, paymentMethod);
            payPs.setString(3, transactionId);
            payPs.setString(4, "Paid");
            payPs.setDouble(5, grandTotal);
            payPs.executeUpdate();

            con.commit();

            payPs.close();
            itemPs.close();
            orderPs.close();
            con.close();

            response.sendRedirect("order-success.jsp?orderId=" + orderId);

        } catch (Exception e) {

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            
            response.sendRedirect(
                    "order-error.jsp?msg=" +
                    java.net.URLEncoder.encode(e.getMessage(), "UTF-8")
                );

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Order Error</h2>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
}