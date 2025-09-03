import 'package:ejarika_app/models/chat.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;

  const ChatCard({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/chat/${chat.id}'),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.advertisement?.title ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          chat.advertisement?.description ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      chat.advertisement!.images.isNotEmpty
                          ? chat.advertisement!.images[0]
                          : '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
