const PAYMENT_URL =
    "http://10.0.2.2:5000/medifly-ce14e/us-central1/customFunctions/payment";

const ORDER_DATA = {
  "orderID": "ORDER_176248",
  "custID": "USER_1234587",
  "custEmail": "someone@gmail.com",
  "custPhone": "7548154458"
};

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";
