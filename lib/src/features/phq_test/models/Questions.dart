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

const List sampleData = [
  {
    "id": 0,
    "question": "Little interest or pleasure in doing things",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 1,
  },
  {
    "id": 1,
    "question": "Feeling down, depressed, or hopeless",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 1,
  },
  {
    "id": 2,
    "question": "Trouble falling or staying asleep, or sleeping too much",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  },
  {
    "id": 3,
    "question": "Feeling tired or having little energy",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "Poor appetite or overeating",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  },
  {
    "id": 5,
    "question":
        "Feeling bad about yourself or that you are a failure or have let yourself or your family down",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  },
  {
    "id": 6,
    "question":
        "Trouble concentrating on things, such as reading the newspaper or watching television",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  },
  {
    "id": 7,
    "question":
        "Moving or speaking so slowly that other people could have noticed. Or the opposite being so figety or restless that you have been moving around a lot more than usua",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  },
  {
    "id": 8,
    "question":
        "Thoughts that you would be better off dead, or of hurting yourself",
    "options": [
      "Not at all",
      "Several days",
      "More than the days",
      "early every day",
    ],
    "answer_index": 2,
  }
];
