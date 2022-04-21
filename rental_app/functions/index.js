/* eslint-disable indent */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

const express = require("express");
const app = express();

app.use(
  express.urlencoded({
    extended: true,
  })
);

app.use(express.json({extended: false}));

app.get("/", (req, res) => {
  const orderId = req.query.instance;
  const status = req.query.message;
  const unixTimestamp = orderId.substring(0, orderId.indexOf("_"));
  const apiAmount = parseInt(
    orderId
      .substring(orderId.indexOf("_") + 1, orderId.indexOf("."))
      .slice(0, -2)
  );
  const userId = orderId.substring(orderId.indexOf(".") + 1, orderId.length);
  console.log(
    "order_id: ",
    orderId,
    "\nstatus: ",
    status,
    "\nuid: ",
    userId,
    "\ntime: ",
    unixTimestamp,
    "\namount: ",
    apiAmount
  );
  res.status(200).send("yahh");
  if (status === "Order Paid") {
    db.collection("users")
      .doc(userId)
      .collection("wallet_transactions")
      .doc(unixTimestamp)
      .set({
        type: "เติมเงิน",
        timestamp: unixTimestamp,
        paymentOrderId: orderId,
        amount: apiAmount,
      });
    db.collection("users")
      .doc(userId)
      .update({
        "wallet.balance": admin.firestore.FieldValue.increment(apiAmount),
      });
  }
});
exports.webhook = functions.region("asia-east2").https.onRequest(app);
