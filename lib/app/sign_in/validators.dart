abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptystringValidator implements StringValidator{
  @override
  bool isValid(String value) {
  return value.isNotEmpty;
  }

}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptystringValidator();
  final StringValidator passwordValidator = NonEmptystringValidator();  
  final String invalidEmailText = 'Email can\'t be empty';
  final String invalidPasswordText = 'Password can\'t be empty';
}