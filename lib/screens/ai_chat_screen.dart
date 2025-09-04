import 'dart:convert';
import 'package:dhan_manthan/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // {role: user/ai, text: ...}
  bool _isLoading = false;

  late final AnimationController _breathCtrl;
  late final Animation<double> _scale;

  // Local predefined Q&A
  final Map<String, String> localQA = {
    "What is stock market?":
        "The stock market is a platform where shares of companies are bought and sold.",
    "What is Sensex?":
        "Sensex is the stock market index of the Bombay Stock Exchange (BSE) that tracks 30 large companies.",
    "What is NSE?":
        "The National Stock Exchange (NSE) is India’s leading stock exchange where equities, derivatives, and currencies are traded.",
    "What is a share?":
        "A share represents ownership in a company and entitles the shareholder to a portion of profits.",
    "What is IPO?":
        "IPO (Initial Public Offering) is when a company offers its shares to the public for the first time.",
    "What is mutual fund?":
        "A mutual fund is a pool of money collected from investors to invest in stocks, bonds, or other assets.",
    "What is dividend?":
        "Dividend is the profit distributed by a company to its shareholders, usually in cash or stock.",
    "What is market capitalization?":
        "Market capitalization is the total value of a company’s shares, calculated as share price × number of shares.",
    "What is equity?":
        "Equity refers to ownership in a company, represented by shares that can be traded in stock markets.",
    "What is portfolio?":
        "A portfolio is a collection of financial assets like stocks, bonds, and mutual funds held by an investor.",
  };

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String query) async {
    setState(() {
      _messages.add({"role": "user", "text": query});
      _isLoading = true;
      _breathCtrl.repeat(reverse: true); // start breathing animation
    });

    // ✅ Local answers first
    if (localQA.containsKey(query)) {
      setState(() {
        _messages.add({"role": "ai", "text": localQA[query]!});
        _isLoading = false;
        _breathCtrl.stop();
      });
      return;
    }

    // 🌐 REST API call to Gemini
    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyAJWqQbB_omg1QLYvUWtMTqsj3p-Rwrhjk",
        ),
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": geminiAPI,
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "You are a financial assistant. STRICT RULE: Only answer finance-related questions. If the question is NOT about finance, money, stocks, investment, banking, rich , wealthy or economics, you MUST reply exactly with: 'Sorry, I can only answer finance-related questions.'\n\nQuestion: $query",
                },
              ],
            },
          ],
        }),
      );

      final data = jsonDecode(response.body);
      final reply =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "Sorry, I couldn't generate a response.";

      setState(() {
        _messages.add({"role": "ai", "text": reply});
        _isLoading = false;
        _breathCtrl.stop();
      });
    } catch (e) {
      setState(() {
        _messages.add({"role": "ai", "text": "Error: $e"});
        _isLoading = false;
        _breathCtrl.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Financial AI Expert",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: bgColor,
      ),
      body: Column(
        children: [
          // 📨 Chat Messages
          Expanded(
            child: _messages.isEmpty
                ? Align(
                    alignment: Alignment.bottomCenter, // fixed
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Image.asset(
                        'assets/images/ai_welcome.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg["role"] == "user";
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.indigo.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg["text"] ?? ""),
                        ),
                      );
                    },
                  ),
          ),

          // 🔄 Loading row with breathing animation OR quick chips
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ScaleTransition(
                        scale: _scale,
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/ai_searching.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: localQA.keys.map((q) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ActionChip(
                          label: Text(q),
                          onPressed: () => _sendMessage(q),
                        ),
                      );
                    }).toList(),
                  ),
                ),

          // 🔤 Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.blue, // cursor color
                    decoration: InputDecoration(
                      hintText: "Ask financial question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // rounded corners
                        borderSide: const BorderSide(
                          color: Colors.grey, // default border color
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                          color: Colors.grey, // border color when not focused
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                          color: Colors.blue, // border color when focused
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        _sendMessage(text.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
