import 'package:flutter/widgets.dart';
import '../../error_handling/domain/failure.dart';
import '../../utils/Constants.dart';
import 'error_handling_widget.dart';

abstract class ErrorHandlingFactoryWidget extends Widget {
  factory ErrorHandlingFactoryWidget(BuildContext context, Failure failure,
      {final void Function()? onClickListener}) {
    // Handle different failure types with specific error messages
    if (failure is NetworkFailure) {
      return ErrorHandlingWidget(
        title: "No internet connection",
        description: "Please check your internet connection and try again",
        image: ImagesPath.noInternetConnectionError,
        tryAgainVisibility: true,
        onClickListener: onClickListener,
      );
    } else if (failure is ServerFailure) {
      return ErrorHandlingWidget(
        title: "Server error",
        description:
            "There is a problem connecting to the server. Please try again later",
        image: ImagesPath.serverError,
        tryAgainVisibility: true,
        onClickListener: onClickListener,
      );
    } else if (failure is DatabaseFailure) {
      return ErrorHandlingWidget(
        title: "Database error",
        description:
            "There was a problem accessing local data. Please try again",
        image: ImagesPath.serverError,
        tryAgainVisibility: true,
        onClickListener: onClickListener,
      );
    } else if (failure is NoDataFoundFailure) {
      return ErrorHandlingWidget(
        title: "No articles found",
        description: "There are no articles available at the moment",
        image: ImagesPath.noFoundData,
        tryAgainVisibility: false,
        onClickListener: onClickListener,
      );
    } else if (failure is TimeoutFailure) {
      return ErrorHandlingWidget(
        title: "Request timeout",
        description: "The request took too long to complete. Please try again",
        image: ImagesPath.serverError,
        tryAgainVisibility: true,
        onClickListener: onClickListener,
      );
    } else if (failure is ValidationFailure) {
      return ErrorHandlingWidget(
        title: "Invalid request",
        description: "There was an issue with your request. Please try again",
        image: ImagesPath.serverError,
        tryAgainVisibility: true,
        onClickListener: onClickListener,
      );
    } else {
      // Default case for UnknownFailure and other types
      return ErrorHandlingWidget(
        title: "An unknown error has occurred",
        description: "Please try again",
        image: ImagesPath.unknownError,
        tryAgainVisibility: true,
        onClickListener: onClickListener,
      );
    }
  }
}
