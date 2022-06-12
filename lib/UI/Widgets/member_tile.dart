import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:flutter/material.dart';

class MemberTile extends StatelessWidget {
  final UserDetails tile;
  final String position;
  const MemberTile({Key? key, required this.tile, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).splashColor.withOpacity(0.2),
        border: Border.all(
          color: Theme.of(context).splashColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(tile.profilePicture),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tile.name,
            style: const TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            position,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
