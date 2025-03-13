import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  String markdownSource = '''
![](https://miro.medium.com/v2/resize:fit:1024/0*vq-JSMynSHUPXx70)  

## 🚀 Express.js Secrets That Senior Developers Don't Share

Express.js is a powerful and lightweight web framework for Node.js, but there are hidden techniques and best practices that senior developers often keep to themselves. In this post, we'll reveal some of these secrets to help you level up your Express.js skills.  

### 1️⃣ Middleware Magic: Conditional Execution  
Most developers use middleware, but did you know you can conditionally execute them based on request properties?  

```js
app.use((req, res, next) => {
  if (req.method === "POST" && req.path.startsWith("/admin")) {
    console.log("Admin route accessed via POST");
  }
  next();
});
```
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 25),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Express.js Secrets That Senior Developers Don't Share",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    'https://avatar.iran.liara.run/public/boy?username=Arunangshu',
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arunangshu Das',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff242424),
                        ),
                      ),
                      Text(
                        'Feb 21, 2025',
                        style: TextStyle(color: Color(0xff6B6B6B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // const Text('Markdown will goes here...', style: TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: MarkdownBody(selectable: true, data: markdownSource),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
