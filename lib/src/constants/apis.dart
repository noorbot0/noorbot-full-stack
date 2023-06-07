class GCloudAPIs {
  static const domain = "https://noorbot-app.web.app";
  static const parlaiRespond = "$domain/parlai/respond";
  static const parlaiGreet = "$domain/parlai/greet";
}

class GPTAPIs {
  static const keyToken = "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";
  static const systemFirstMessagePrompt =
      "Act as a Therapist. Your name is Noor. You are a helpful therapy assistant. Intreduce name and you can help people feel better and make them happy, then ask user the name. After that start asking about mental health things and how does user feel?";
  static const firstMessagePrompt =
      "Hello! My name is Noor and I'm here to help you feel better and happier. What's your name?";
  // String prpt = "Classify the sentiment in these tweets:\n\n$message\n";
  static sentimentPrompt(String message) =>
      "Classify whether a sentence's sentiment is positive, neutral, or negative. No full stop.\n\n$message\n";
  static nameExtractPrompt(String message) =>
      "Extract the name from the following text: $message. Please provide the extracted name.";
  // "Extract the speaker name if provided otherwise say none and don't say anything else.\n\n$message.\n";
  static defaultAnswersPrompt(String message) =>
      "Respond to the following message: $message of max 4 words";
  // "Respond to the following message with specific and clear answers in three responses, each containing a maximum of three words and seperated with commas.\n\nMessage: \"$message\"";
  //A comma separates them
  // "Respond to the following message with at most 3 responses, using 3 words or less for each response. A comma separates them:\n\nMessage: \"$message\"";
  // "Respond with 2 responses to this message with 3 words only. A comma separates them. No full stop. No repetition.\n\n$message\n";
  // "Respond with 3 responses only to this message with 1 to 3 words only. A comma separates them. Don't say anything else. No full stop. No repetition.\n\n$message\n";

  static extractSentiments(String message) =>
      "Extract sentiments words, otherwise, say none: $message \n\nPositive:\nNegative:";
  static giveEmojisToSentiments(String message) =>
      "Give emojis to these sentiments, with comma seperated: $message";
}
