import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Quiz App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizScreen()),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _score = 0;
  String _currentLevel = 'Easy';

  final Map<String, List<Map<String, Object>>> _levels = {
    'Easy': [
      {
        'questionText': 'What is the capital of France?',
        'answers': [
          {'text': 'Berlin', 'score': 0},
          {'text': 'Paris', 'score': 1},
          {'text': 'Madrid', 'score': 0},
          {'text': 'Rome', 'score': 0},
        ],
      },
      {
        'questionText': 'Which is the largest planet?',
        'answers': [
          {'text': 'Earth', 'score': 0},
          {'text': 'Jupiter', 'score': 1},
          {'text': 'Mars', 'score': 0},
          {'text': 'Saturn', 'score': 0},
        ],
      },
      {
        'questionText': 'What is the capital of Japan?',
        'answers': [
          {'text': 'Beijing', 'score': 0},
          {'text': 'Seoul', 'score': 0},
          {'text': 'Tokyo', 'score': 1},
          {'text': 'Bangkok', 'score': 0},
        ],
      },
      {
        'questionText': 'Which is the smallest prime number?',
        'answers': [
          {'text': '0', 'score': 0},
          {'text': '1', 'score': 0},
          {'text': '2', 'score': 1},
          {'text': '3', 'score': 0},
        ],
      },
      // Add more easy questions as needed
    ],
    'Medium': [
      {
        'questionText': 'Who wrote the play "Romeo and Juliet"?',
        'answers': [
          {'text': 'Charles Dickens', 'score': 0},
          {'text': 'William Shakespeare', 'score': 1},
          {'text': 'Jane Austen', 'score': 0},
          {'text': 'Mark Twain', 'score': 0},
        ],
      },
      {
        'questionText': 'In which year did World War II end?',
        'answers': [
          {'text': '1943', 'score': 0},
          {'text': '1944', 'score': 0},
          {'text': '1945', 'score': 1},
          {'text': '1946', 'score': 0},
        ],
      },
      // Add more medium questions as needed
    ],
    'Hard': [
      {
        'questionText': 'What is the speed of light?',
        'answers': [
          {'text': '299,792 kilometers per second', 'score': 1},
          {'text': '150,000 kilometers per second', 'score': 0},
          {'text': '500,000 kilometers per second', 'score': 0},
          {'text': '750,000 kilometers per second', 'score': 0},
        ],
      },
      {
        'questionText': 'Who developed the theory of relativity?',
        'answers': [
          {'text': 'Isaac Newton', 'score': 0},
          {'text': 'Albert Einstein', 'score': 1},
          {'text': 'Niels Bohr', 'score': 0},
          {'text': 'Galileo Galilei', 'score': 0},
        ],
      },
      // Add more hard questions as needed
    ],
  };

  void _answerQuestion(int score) {
    setState(() {
      _score += score;
      _questionIndex++;
    });
  }

  void _changeLevel(String level) {
    setState(() {
      _currentLevel = level;
      _questionIndex = 0;
      _score = 0;
    });
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _score = 0;
      _currentLevel = 'Easy';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App - $_currentLevel Level'),
      ),
      body: _questionIndex < _levels[_currentLevel]!.length
          ? Quiz(
              questionIndex: _questionIndex,
              questions: _levels[_currentLevel]!,
              answerQuestion: _answerQuestion,
            )
          : Result(_score, _resetQuiz, _changeLevel),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Easy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_half),
            label: 'Medium',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Hard',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            _changeLevel('Easy');
          } else if (index == 1) {
            _changeLevel('Medium');
          } else {
            _changeLevel('Hard');
          }
        },
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  final int questionIndex;
  final List<Map<String, Object>> questions;
  final Function answerQuestion;

  Quiz({
    required this.questionIndex,
    required this.questions,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[questionIndex]['questionText'] as String),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(
            () => answerQuestion(answer['score'] as int),
            answer['text'] as String,
            answer['score'] == 1,
          );
        }).toList(),
      ],
    );
  }
}

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;
  final bool isCorrect;

  Answer(this.selectHandler, this.answerText, this.isCorrect);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          selectHandler();
        },
        child: Text(
          answerText,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int score;
  final VoidCallback resetHandler;
  final Function changeLevel;

  Result(this.score, this.resetHandler, this.changeLevel);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You scored $score points!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: resetHandler,
            child: Text('Restart Quiz'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              changeLevel();
            },
            child: Text('Change Level'),
          ),
        ],
      ),
    );
  }
}
