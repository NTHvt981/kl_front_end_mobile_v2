class PaymentData {
  // singleton boilerplate
  static final PaymentData _instance = PaymentData._internal();

  factory PaymentData() {
    return _instance;
  }

  // singleton boilerplate
  PaymentData._internal() {

  }

  //------------------PRIVATE ATTRIBUTES------------------//
  String cardName = '';
  String cardNumber = '';
  String expireDate = '';
  String cvc = '';
}