import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

class QuestionOptionsItem extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback press;
  final bool isAnswered;

  const QuestionOptionsItem({
    super.key,
    required this.text,
    required this.index,
    required this.press,
    required this.isAnswered,
  });

  @override
  Widget build(BuildContext context) {
    const kGreenColor = Color(0xFF6AC259);
    const kRedColor = Color(0xFFE92E30);

    Color getTheRightColor() {
      if (isAnswered) {
        /*if (index == qnController.correctAns) {
          return kGreenColor;
        } else if (index == qnController.selectedAns &&
            qnController.selectedAns != qnController.correctAns) {
          return kRedColor;
        }*/

        return kGreenColor;
      }
      return kGrayColor;
    }

    IconData getTheRightIcon() {
      return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
    }

    return InkWell(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.only(top: kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          border: Border.all(color: getTheRightColor()),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${index + 1}. $text",
              style: TextStyle(color: getTheRightColor(), fontSize: 16),
            ),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: getTheRightColor() == kGrayColor
                    ? Colors.transparent
                    : getTheRightColor(),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: getTheRightColor()),
              ),
              child: getTheRightColor() == kGrayColor
                  ? null
                  : Icon(getTheRightIcon(), size: 16),
            )
          ],
        ),
      ),
    );
  }
}
