# BookVote - Book Voting System

A **clean and elegant book voting platform** that lets readers vote for their favorite books!

> **"Give every book a chance to shine!"**

![GitHub stars](https://img.shields.io/github/stars/shaunxu421/bookvote?style=social)
![GitHub forks](https://img.shields.io/github/forks/shaunxu421/bookvote?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/shaunxu421/bookvote?style=social)
![GitHub license](https://img.shields.io/github/license/shaunxu421/bookvote)
![Java](https://img.shields.io/badge/Java-1.8%2B-blue)
![Tomcat](https://img.shields.io/badge/Tomcat-8.5%2B-orange)
![Maven](https://img.shields.io/badge/Maven-3.6%2B-green)

<img width="2555" height="1558" alt="image" src="https://github.com/user-attachments/assets/b9032866-fff9-4431-9570-7df74764aa49" />
<img width="2407" height="1491" alt="image" src="https://github.com/user-attachments/assets/fdb75f51-6e2e-40cb-8213-f47e1ef9dcf3" />
<img width="2553" height="1459" alt="image" src="https://github.com/user-attachments/assets/4d2ccc3f-b8cc-4148-bc39-2e7f68575b48" />
<img width="1241" height="1291" alt="image" src="https://github.com/user-attachments/assets/0441ddf4-7a3f-42d2-9807-398f8e545236" />

---

## Features

| Feature | Description |
|--------|-------------|
| **Book Showcase** | Dynamically display book covers, authors, and descriptions |
| **Real-time Voting** | One-click voting with anti-spam protection |
| **Live Leaderboard** | Real-time Top 10 hottest books |
| **User System** | Registration, login, and vote history tracking |
| **Responsive Design** | Works perfectly on desktop and mobile |

---

## Tech Stack

```text
Backend     → Java Servlet + JSP
Frontend    → HTML5 + CSS3 + Bootstrap
Build Tool  → Apache Maven
Server      → Apache Tomcat 8.5+
Database    → MySQL 5.7+ (optional)

Quick Start (Run in 3 Minutes!)
1. Clone the Project
bashgit clone https://github.com/shaunxu421/bookvote.git
cd bookvote
2. Open in IntelliJ IDEA

Open IntelliJ IDEA
File → Open → Select the bookvote folder
Wait for Maven to download dependencies

3. Configure Tomcat

Run → Edit Configurations
Click + → Tomcat Server → Local
Set Tomcat path
Deploy in war exploded mode
Start the server

4. Access the App
texthttp://localhost:8080/
First load may take a few seconds — please be patient!

Project Structure
textbookvote/
├── src/
│   ├── main/
│   │   ├── java/           → Core Servlet logic
│   │   │   ├── servlet/    → Voting, login controllers
│   │   │   └── util/       → DB connection, utilities
│   │   ├── webapp/         → JSP pages + static assets
│   │   │   ├── WEB-INF/    → web.xml config
│   │   │   ├── css/        → Styles
│   │   │   ├── js/         → Scripts
│   │   │   └── *.jsp       → Login, vote, leaderboard pages
│   └── resources/          → Config files
├── pom.xml                 → Maven dependencies
├── .gitignore              → Ignores IDE & build files
└── README.md               → This file

Screenshots
Upload these to a screenshots/ folder














HomeVoting PageLeaderboardHomeVoteLeaderboard

Database Setup (Optional)

Create database:

sqlCREATE DATABASE bookvote CHARACTER SET utf8mb4;

Import schema (sql/bookvote.sql):

bashmysql -u root -p bookvote < sql/bookvote.sql

Update DB config in src/main/java/util/DBUtil.java.


Contributing
We welcome all contributions!
bash# 1. Fork the repo
# 2. Create your feature branch
git checkout -b feature/cool-ui

# 3. Commit your changes
git commit -m "feat: add voting animation"

# 4. Push to your fork
git push origin feature/cool-ui

# 5. Open a Pull Request

Roadmap

 Add book search
 Custom book cover upload
 Voting trend charts (ECharts)
 WeChat Mini Program version
 Multi-language support (EN/CN)


License
This project is licensed under the MIT License
Feel free to use, modify, and distribute — just keep the copyright notice.

Contact

GitHub: @shaunxu421
Email: xiaoxuyang@gmail.com (replace with yours)
Project Link: https://github.com/shaunxu421/bookvote


Love this project? Give it a Star!Your star means the world to open source!
