import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.mediaObject});
  final mediaObject;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        
      },
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 6 / 10,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: mediaObject["image"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                mediaObject["title"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
                Text(
                "Ep: ${mediaObject["sub"]}",
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey.shade600
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
