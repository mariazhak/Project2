import 'dart:io';

//a class which stores data about each product
class Product {
  String name;
  num price;
  int amount;

  //constructor for product
  Product({required this.name, this.price =-1 , this.amount=-1});

  //example constructor to showcase initialising constructor (it is used to create sample product)
  Product.example(): name= 'Pepsi mint', price = 35, amount=50;

  //factory constructor which creates product or special based on flag called special
  factory Product.special({required special, required name, price, amount, discount}){
    return special ? Special(name, discount, price, amount) : Product(name: name, price: price, amount: amount);
  }
  
  //function which prints out information about product in certain form
  void printProduct () {
    print('$name');
    price!=-1 ? print('Price: $price hryivnyas'): print('Price: Unknown price');
    amount!=-1 ? print('Amount available: $amount'): print('Amount: Unknown amount');
  }

  //prints info about product in file
  void printProductFile(File f){
    f.writeAsString(name);
    f.writeAsString('$price');
    f.writeAsString('$amount');
    f.writeAsString('0');
  }
}

//child class of product which represents products with discounts
class Special extends Product{
  num discount;

  Special(name, this.discount, [price=-1 , amount=-1]):super(name:name, price: price, amount: amount);

  // function which prints out info about special object(same as product, but with discount property)
  void printInfo(){
    printProduct();
    print('Discount : $discount%');
    num newPrice = price!=-1 ? price - price*discount/100: -1;
    newPrice !=-1 ? print('New price: $newPrice hryivnyas'): print('New price: Unknown Price');
  }

  //function which prints out info about special product in file 
  void printProductFileSpecial(File f){
    f.writeAsString(name);
    f.writeAsString('$price');
    f.writeAsString('$amount');
    f.writeAsString('$discount');
  }
}

//mixin which operates all created substract functions
mixin Substractors{
  var substractors = <String, Function>{};

  Function _createSubstractor([num Base=0]) {
    return (num price) => price!= -1 ? price - Base: -1;
  }

  void addSubstractor(String description, num Base){
    substractors[description]= _createSubstractor(Base);
  }

  void printSubstractors(){
    print('Available substractors:');
    int counter = 1;
      substractors.forEach((key, value) { 
      print('$counter. Substract $key');
      counter++;
      });
  }

  bool anySubstractors() => substractors.isEmpty ? false : true ;
}

//mixin which operates all created add functions
mixin Adders{
  var adders = <String, Function>{};

  Function _createAdder([num Base=0]) {
    return (num price) => price != -1 ? price + Base: -1;
  }

  void addAdder(String description, num Base){
    adders[description]= _createAdder(Base);
  }

  void printAdders(){
    print('Available adders:');
    int counter = 1;
      adders.forEach((key, value) { 
      print('$counter. Add $key');
      counter++;
      });
  }

  bool anyAdders() => adders.isEmpty ? false : true ;
}

//class which contains all operations made after a user chooses something from menu. It uses Adder and Substractor mixins to change prices
class ListProccessor with Adders, Substractors{
  var list = <Product>[];

  //function which adds products to list until the user decides to exit
  void addElements(){
    print('Please type asked info about the product:');
    String? checker = 'y'; //checker is needed to know when to exit the while loop
    while (checker != 'e'){
      //reading the name of product. It can be an empty String
      print('Print name of the product you want to add:');
      var name = stdin.readLineSync() ?? 'Unknown name'; 

      //reading the price. If the price is empty, product stores -1, which corresponds to unknown price
      print('Print price of the product you want to add:');
      var priceStr = stdin.readLineSync();
      var price = priceStr != '' ? double.parse(priceStr!) : -1;

      //this block of code reads the amount. If the amount is empty, product stores -1, which corresponds to unknown amount
      print('Print available amount of the product:');
      var amountStr = stdin.readLineSync();
      var amount = amountStr != '' ? int.parse(amountStr!) : -1;

      //deciding whether the product will be special or not, and using fabric constructor to create the needed object.
      print('Do you want to add the product to specials? Print y for yes');
      if (stdin.readLineSync()=='y'){
        print('Enter the discount:');
        var discountStr = stdin.readLineSync();
        var discount = discountStr != null ? int.parse(discountStr) : null;
        list.add(Product.special(special: true, name: name, price: price,amount: amount, discount: discount??0));
      }
      else {
        list.add(Product.special(special: false, name: name, price: price,amount: amount));
      }
      
      //changing the value of checker
      print('Do you want to continue adding? Press any symbol, or press e to exit.');
      checker = stdin.readLineSync();
      checker??='e';
    }
  }

  //this function prints information about all products
  void showElements(){
    if (list.isEmpty){
      print('No products added yet!');
    }
    else{
      print('Here is the list of all stored products:');
      int counter = 1;
      list.forEach((element) {
        stdout.write('$counter:');
        element is Special ? element.printInfo() : element.printProduct();
        counter++;
      });
    }
  }
  
  //this function removes elements until the user decides to exit
  void removeElements(){
    String checker = 'y';
    while (checker != 'e'){
      print('Enter the number of element you want to remove:');
      String? number = stdin.readLineSync() ?? '-1';
      if (number != '-1'){
        list.removeAt(int.parse(number)-1);
      }
      print('Product is succesfully removed! Do you want to continue? Press any character to continue and e to exit');
      checker = stdin.readLineSync() ?? 'e';
    } 
  }

  //this function prints out info about Special objects
  void showSpecials(){
    print('Here is the list of all specials:');
    int counter = 1;
    list.forEach((element) {
      if (element is Special){
        stdout.write('$counter:');
        element.printInfo();
        counter++;
      }
    });
  }

  //this function is used to change prices and create patterns to change prices
  void priceChangers(){
    String? checker = 'y'; //checker is used to exit the while loop
    while (checker != 'e'){
      print('Do you want to change the price or add new adder/substractor? Press p to change price, and a to add new adder, s to add new substractor, and e to exit');
      checker = stdin.readLineSync();
      //if user decides to change price
      if (checker == 'p') {
        if (list.isEmpty){
          print('You do not have products yet!');
        }
        else{
        showElements();
        print('Which one do you want to add price to or substract from? Print the number in the list');
        int priceElem = int.parse(stdin.readLineSync()!);
        anyAdders() ? printAdders() : print('You do not have any adders yet!');
        anySubstractors() ? printSubstractors() : print('You do not have any substractors yet!'); 
        //if there are no adders and substractors yet, the user cannot change any price
        if (anyAdders() || anySubstractors()){
          print('Choose if you want to use adder or substractor? Print a for adder and s for substractor');
          String input = stdin.readLineSync()!;
          //changing price with adders
          if (input == 'a'){
            print('Enter the base of adder you want to use:');
            String keey = stdin.readLineSync()!;
            adders[keey]!= null ? list[priceElem-1].price=adders[keey]!(list[priceElem-1].price) : print('Sorry, wrong input!');
          }
          //changing price with substractors
          else if (input == 's'){
            print('Enter the base of substractor you want to use:');
            String keey = stdin.readLineSync()!;
            substractors[keey]!= null ? list[priceElem-1].price=substractors[keey]!(list[priceElem-1].price) : print('Sorry, wrong input!');
          }
          else { print('Sorry, wrong input!'); }
        }
      }
      }
      //adding adder
      else if (checker == 'a'){
        print('Please enter the number for new adder Base:');
        String? value = stdin.readLineSync();
        value != '' ? addAdder(value!, num.parse(value)) : print('Try again please!');
      }
      //adding substractor
      else if (checker == 's'){
        print('Please enter the number for new substractor Base:');
        String? value = stdin.readLineSync();
        value != '' ? addSubstractor(value!, num.parse(value)) : print('Try again please!');
      }
      else if (checker != 'e'){
        print('Sorry, wrong command!');
      }
    } 
  }

  //this function reads info from file
  void readFile(File f){
    List<String> inputs = f.readAsLinesSync();
    for (int i=0; i<inputs.length; i=i+4){
      var name = inputs[i];
      var price = num.parse(inputs[i+1]);
      var amount = int.parse(inputs[i+2]);
      var discount = num.parse(inputs[i+3]);
      var special = true;
      if (discount == 0) {special = false;}
      list.add(Product.special(special: special, name: name, price: price, amount:amount, discount:discount));
    }
    print('Data is successfully read!');
  }

  //printing all products into the file
  void printFile(File f){
    f.writeAsStringSync('');
    list.forEach((element) {
      element is Special ? element.printProductFileSpecial(f) : element.printProductFile(f);
    });
  }
}

//this functions prints options to the user and get their decision
String Menu(){
  print('Choose from the following options:');
  print('1. View existing products');
  print('2. Add new products');
  print('3. Remove products');
  print('4. View specials');
  print('5. Change price');
  print('6. Show sample product');
  print('7. Read samples from file');
  print('8. Exit');
  print('Print the number to proceed');
  var input = stdin.readLineSync();
  assert(input != '');
  input ??= '8';
  int intInput = int.parse(input);
  assert(intInput>0 && intInput<8);
  return input;
}

void main(){
  File f = new File('savings.txt');
  var decisionMaker = ListProccessor();
  var example = Product.example();
  print('Welcome to your store storage!');
  String choice = Menu();
  while(choice != '8'){
    switch (choice){
      case '1': decisionMaker.showElements();
      case '2': decisionMaker.addElements();
      case '3': decisionMaker..showElements()..removeElements();
      case '4': decisionMaker.showSpecials();
      case '5': decisionMaker.priceChangers();
      case '6': example.printProduct();
      case '7': decisionMaker.readFile(f);
   }
   choice = Menu();
  }
  //print('Do you want to save changes to file? Print y to do so, and every other character to exit');
  //if (stdin.readLineSync()! == 'y') {decisionMaker.printFile(f);};

  print('Thanks for using this app simulator! Goodbye!');
} 