[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/vhTsyc6D)
Welcome to your SQL Term Group Project! This repository is set up with GitHub Actions, which means your queries will be automatically graded every time you "Push" your code to GitHub.

🚀 How to Complete this Assignment
Open the file named solution.sql in this repository.

Write your query inside that file.

Note: Unless instructed otherwise, provide only the SELECT statement.

Commit and Push your changes to GitHub.

Check your progress: Go to the Actions tab in this repository to see if your query passed or failed.

✅ Green check: Your output matches the answer key!

❌ Red X: Something is wrong (Syntax error or incorrect data).

🛠 Database Environment
This assignment uses: [Insert MySQL or PostgreSQL here]

Schema: The tables and data are pre-loaded into the autograder using data/setup.sql. You do not need to run CREATE TABLE commands in your solution.

Database Name: test_db

⚠️ Critical Submission Rules
To ensure the autograder can read your work, please follow these rules strictly:

Order Matters: If the instructions ask for sorted data, you must use ORDER BY. The autograder compares your result row-by-row; if the order is different, it will mark it as wrong.

Column Names: Your output must have the exact column names (aliases) requested in the prompt. Use AS if necessary (e.g., SELECT COUNT(*) AS total_users).

No Extra Text: Do not include comments or extra SQL commands (like USE database; or DESCRIBE table;) in your solution.sql unless specified.

Case Sensitivity: Be mindful of string comparisons (e.g., 'London' is not the same as 'london' in some SQL dialects).

🔍 How to Debug a Failure
If you see a Red X in the Actions tab:

Click on the failed "Autograding" run.

Expand the "Run Autograder" or "Compare Results" step.

The logs will show a "Diff."

Lines starting with - are what the answer key expected.

Lines starting with + are what your query produced.
