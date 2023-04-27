class Question {
  final int id, answer;
  final String question;
  final List<String> options;

  Question(
      {required this.id,
      required this.question,
      required this.answer,
      required this.options});
}

const List sample_data = [
  {
    "id": 0,
    "question": "How old are you?",
    "options": [
      "15 - 25 years old",
      "25 - 35 years old",
      "35 - 45 years old ",
      "more than 45",
    ],
    "answer_index": 1,
  },
  {
    "id": 1,
    "question": "",
    "options": [
      "I do not feel sad.",
      "I feel sad ",
      "I am sad all the time and I can't snap out of it. ",
      "I am so sad and unhappy that I can't stand it.",
    ],
    "answer_index": 1,
  },
  {
    "id": 2,
    "question": "",
    "options": [
      "I am not particularly discouraged about the future. ",
      "I feel discouraged about the future.",
      "I feel I have nothing to look forward to. ",
      "I feel the future is hopeless and that things cannot improve.",
    ],
    "answer_index": 2,
  },
  {
    "id": 3,
    "question": "",
    "options": [
      "I do not feel like a failure. ",
      "I feel I have failed more than the average person. ",
      "As I look back on my life, all I can see is a lot of failures.",
      "I feel I am a complete failure as a person.",
    ],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "",
    "options": [
      "I get as much satisfaction out of things as I used to.",
      "I don't enjoy things the way I used to. ",
      "I don't get real satisfaction out of anything anymore.",
      "I am dissatisfied or bored with everything.",
    ],
    "answer_index": 2,
  },
  {
    "id": 5,
    "question": "",
    "options": [
      "I don't feel particularly guilty",
      "I feel guilty a good part of the time.",
      "I feel quite guilty most of the time. ",
      "I feel guilty all of the time.",
    ],
    "answer_index": 2,
  },
  {
    "id": 6,
    "question": "",
    "options": [
      "I don't feel I am being punished.",
      "I feel I may be punished.",
      "I expect to be punished.  ",
      "I feel I am being punished.",
    ],
    "answer_index": 2,
  },
  {
    "id": 7,
    "question": "",
    "options": [
      "I don't feel disappointed in myself.",
      "I am disappointed in myself.",
      "I am disgusted with myself. ",
      "I hate myself.",
    ],
    "answer_index": 2,
  },
  {
    "id": 8,
    "question": "",
    "options": [
      "I don't feel I am any worse than anybody else.",
      "I am critical of myself for my weaknesses or mistakes.",
      "I blame myself all the time for my faults.",
      "I blame myself for everything bad that happens.",
    ],
    "answer_index": 2,
  },
  {
    "id": 9,
    "question": "",
    "options": [
      "I don't have any thoughts of killing myself.",
      "I have thoughts of killing myself, but I would not carry them out.",
      "I would like to kill myself.",
      "I would kill myself if I had the chance.",
    ],
    "answer_index": 2,
  },
  {
    "id": 10,
    "question": "",
    "options": [
      "I don't cry any more than usual.",
      "I cry more now than I used to.",
      "I cry all the time now.",
      "I used to be able to cry, but now I can't cry even though I want to.",
    ],
    "answer_index": 2,
  },
  {
    "id": 11,
    "question": "",
    "options": [
      "I am no more irritated by things than I ever was.",
      "I am slightly more irritated now than usual.",
      "I am quite annoyed or irritated a good deal of the time.",
      "I feel irritated all the time.",
    ],
    "answer_index": 2,
  },
  {
    "id": 12,
    "question": "",
    "options": [
      "I have not lost interest in other people. ",
      "I am less interested in other people than I used to be.",
      "I have lost most of my interest in other people.",
      "I have lost all of my interest in other people.",
    ],
    "answer_index": 2,
  },
  {
    "id": 13,
    "question": "",
    "options": [
      "I make decisions about as well as I ever could.",
      "I put off making decisions more than I used to.",
      "I have greater difficulty in making decisions more than I used to.",
      "I can't make decisions at all anymore.",
    ],
    "answer_index": 2,
  },
  {
    "id": 14,
    "question": "",
    "options": [
      "I don't feel that I look any worse than I used to.",
      "I am worried that I am looking old or unattractive.",
      "I feel there are permanent changes in my appearance that make me look unattractive.",
      "I believe that I look ugly.",
    ],
    "answer_index": 2,
  },
  {
    "id": 15,
    "question": "",
    "options": [
      "I can work about as well as before.",
      "It takes an extra effort to get started at doing something.",
      "I have to push myself very hard to do anything. ",
      "I can't do any work at all.",
    ],
    "answer_index": 2,
  },
  {
    "id": 16,
    "question": "",
    "options": [
      "I can sleep as well as usual.",
      "I don't sleep as well as I used to. ",
      "I wake up 1-2 hours earlier than usual and find it hard to get back to sleep.",
      "I wake up several hours earlier than I used to and cannot get back to sleep.",
    ],
    "answer_index": 2,
  },
  {
    "id": 17,
    "question": "",
    "options": [
      "I don't get more tired than usual. ",
      "I get tired more easily than I used to.",
      "I get tired from doing almost anything.",
      "I am too tired to do anything. ",
    ],
    "answer_index": 2,
  },
  {
    "id": 18,
    "question": "",
    "options": [
      "My appetite is no worse than usual. ",
      "My appetite is not as good as it used to be. ",
      "My appetite is much worse now. ",
      "I have no appetite at all anymore. ",
    ],
    "answer_index": 2,
  },
  {
    "id": 19,
    "question": "",
    "options": [
      "I haven't lost much weight, if any, lately.",
      "I have lost more than five pounds. ",
      "I have lost more than ten pounds.",
      "I have lost more than fifteen pounds.",
    ],
    "answer_index": 2,
  },
  {
    "id": 20,
    "question": "",
    "options": [
      "I am no more worried about my health than usual. ",
      "I am worried about physical problems like aches ",
      "I am very worried about physical problems and it's hard to think of much else. ",
      "I am so worried about my physical problems  ",
    ],
    "answer_index": 2,
  },
];
