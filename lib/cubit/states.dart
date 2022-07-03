abstract class MyStates{}
//main
class MyInitState extends MyStates{}
class MyChangeState extends MyStates{}
//chat
class SendMessageSuccessState extends MyStates{}
class SendMessageErrorState extends MyStates{}
class GetMessageSuccessState extends MyStates{}
class GetMessageErrorState extends MyStates{}