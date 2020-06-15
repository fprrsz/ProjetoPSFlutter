import 'package:ProjetoPSFlutter/widgets/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ProjetoPSFlutter/models/chat_message.dart';
import 'package:ProjetoPSFlutter/widgets/chat_message_list_item.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatPage extends StatefulWidget {
  final String botName;
  final String userName;

  ChatPage({this.botName = "James", this.userName = "User"});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

  //void _sendMessage({String text}) {
    //Firestore.instance
      //  .collection('messages')
        //.document()
        //.setData({'text': text});
        //_addMessage(name: 'User', text: text, type: ChatMessageType.sent);
  //}

    @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: <Widget>[
      _buildList(),
      Divider(height: 1.0),
      TextComposer(_sendMessage),
    ],
  ));

// Cria a lista de mensagens (de baixo para cima)
  Widget _buildList() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  // Envia uma mensagem com o padrão a direita
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(name: widget.userName, text: text, type: ChatMessageType.sent);
  }

  // Adiciona uma mensagem na lista de mensagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(text: text, name: name, type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
    }
  }

  Future _dialogFlowRequest({String query}) async {
    // Adiciona uma mensagem temporária na lista
    _addMessage(
        name: widget.botName,
        text: 'Escrevendo...',
        type: ChatMessageType.received);

    // Faz a autenticação com o serviço, envia a mensagem e recebe uma resposta da Intent
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/key.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.portugueseBrazilian);
    AIResponse response = await dialogflow.detectIntent(query);

    // remove a mensagem temporária
    setState(() {
      _messageList.removeAt(0);
    });

    // adiciona a mensagem com a resposta do DialogFlow
    _addMessage(
        name: widget.botName,
        text: response.getMessage() ?? '',
        type: ChatMessageType.received);
  }
}
