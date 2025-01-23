import 'package:flutter/material.dart';
import 'package:rider/constants/asesets.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.isProfilePic = false,
    this.radius = 50,
    this.height,
    this.width,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.fit,
    this.bottomRightRadius,
  }) : super(key: key);

  final String url;
  final BoxFit? fit;
  final double radius;
  final bool isProfilePic;
  final double? height, width;
  final double? topLeftRadius, topRightRadius;
  final double? bottomLeftRadius, bottomRightRadius;

  @override
  Widget build(BuildContext context) {
    return isProfilePic
        ? CircleAvatar(
            radius: radius,
            backgroundImage: const NetworkImage(
                "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="),
            foregroundImage: NetworkImage(url.isEmpty
                ? "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="
                : url),
          )
        // .animate(delay: 300.ms)
        // .moveX()
        // .fadeIn(duration: 400.ms)
        : ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius ?? 0),
              topRight: Radius.circular(topRightRadius ?? 0),
              bottomLeft: Radius.circular(bottomLeftRadius ?? 0),
              bottomRight: Radius.circular(bottomRightRadius ?? 0),
            ),
            child: Image.asset("$kcStaticImagesPath/place_pro.jpeg",
                fit: BoxFit.cover)

            // CachedNetworkImage(
            //     imageUrl:
            //         "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
            //     fit: fit ?? BoxFit.cover,
            //     height: height,
            //     width: width,
            //     placeholder: (context, url) => SizedBox(
            //       height: height,
            //       width: width,
            //       child: const SpinKitFadingCircle(
            //         color: kcPrimaryColor,
            //         size: 60,
            //       ),
            //     ),
            //     errorWidget: (context, url, error) => Image.asset(
            //       "$kcStaticImagesPath/place_pro.jpeg",
            //       fit: BoxFit.cover,
            //       height: height,
            //       width: width,
            //     ),
            //     imageBuilder: (context, imageProvider) => Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: imageProvider,
            //           fit: fit ?? BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //   )
            );
    // .animate(delay: 200.ms).moveX().fadeIn(duration: 300.ms);
  }
}
