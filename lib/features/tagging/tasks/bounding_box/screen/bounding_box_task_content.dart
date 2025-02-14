import 'package:flutter/material.dart';

import '../bloc/bounding_box_task_cubit.dart';
import '../widgets/bounding_box_image.dart';

class BoundingBoxTaskContent extends StatelessWidget {
  final BoundingBoxTaskState state;

  const BoundingBoxTaskContent({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Center(
                  child: BoundingBoxImage(state: state),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text('Car dhahsdhsahj h'),
                              SizedBox(width: 100),
                              Material(
                                child: InkWell(
                                  customBorder: CircleBorder(),
                                  onTap: () {},
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
