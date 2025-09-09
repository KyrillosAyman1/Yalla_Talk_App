import 'package:flutter/material.dart';

void customShowDialog({required BuildContext context,required String title,required String content,Color? color}) {

                                  showDialog(

                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
          
                                      backgroundColor:color?? Theme.of(context).colorScheme.primaryContainer,
                                      title: Text(title),
                                      content: Text(content),
                                      actions: [
                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
}
