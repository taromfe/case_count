package com.microfocus.sugahara.taro.case_count;

import java.sql.*;
import java.util.*;
import java.io.*;

public class DatabaseController {

	static final String usageMessage =
		"Usage:\n" +
		"\t-show-usage\n" +
		"\t\tShow this message.\n\n" +
		"\t-init-db DATABASE_FILE_NAME\n" +
		"\t\tInitialize database\n\n" +
		"\t-add-user DATABASE_FILE_NAME USER_EMAIL_ADDRESS" +
		"\t\tAdd a user\n\n" +
		"\t-add-users-in-file DATABASE_FILE_NAME USER_LIST_FILE\n" +
		"\t\tAdd users listed in file";

	public DatabaseController() {
		// TODO Auto-generated constructor stub
	}

	public static void main(String[] args) {
				
		if (args.length == 0) {
			showUsage("ERROR: Invalid command line.");
			System.exit(1);
		} else {
			String optionSwitch = args[0];
			if ("-init-db".equals(optionSwitch)) {
				if (args.length != 2) {
					showUsage("ERROR: Invalid command line.");
					System.exit(1);
				} else {
					try {
						initDatabase(args[1]);
					} catch (Exception e) {
						System.out.println("ERROR: Failed to initialize database.");
						System.out.println(e.getMessage());
					}
				}
			} else if ("-show-usage".equals(optionSwitch)) {
				showUsage(null);
				System.exit(0);
			} else if ("-add-user".equals(optionSwitch)) {
				if (args.length != 3) {
					showUsage("ERROR: Invalid command line.");
					System.exit(1);
				} else {
					String dbName = args[1];
					String[] users = new String[1];
					users[0] = args[2];
					try {
						addUsers(dbName, users);
					} catch (Exception e) {
						System.out.println("ERROR: Failed to add a user.");
						System.out.println(e.getMessage());
					}
				}
			} else if ("-add-users-in-file".equals(optionSwitch)) {
				if (args.length != 3) {
					showUsage("ERROR: Invalid command line.");
					System.exit(1);
				} else {
					try {
						String dbName = args[1];
						String fileName = args[2];
						String[] users = getUsersInFile(fileName);
						addUsers(dbName, users);
					} catch (Exception e) {
						System.out.println("ERROR: Failed to add users from file.");
						System.out.println(e.getMessage());
					}
				}
			} else {
				showUsage("ERROR: Invalid option switch" + optionSwitch);
				System.exit(1);
			}
		}
	}
	
	static void showUsage(String message) {
		if (message != null && message.length() > 0) {
			System.out.println(message);
		}
		System.out.println(usageMessage);
	}
	
	static void initDatabase(String dbFileName) throws Exception {
		//Class.forName("org.sqlite.JDBC");
		
		try (Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbFileName)) {
			try (Statement stmt =  conn.createStatement()) {
				// Delete old databases.
				stmt.execute("DROP TABLE IF EXISTS support_case");
				stmt.execute("DROP TABLE IF EXISTS pickup_type");
				stmt.execute("DROP TABLE IF EXISTS user");
				
				// Create tables.
				stmt.execute("CREATE TABLE user (id INTEGER PRIMARY KEY, email TEXT, password TEXT)");
				stmt.execute("CREATE TABLE pickup_type (id INTEGER PRIMARY KEY, type TEXT)");
				stmt.execute("CREATE TABLE support_case (id INTEGER PRIMARY KEY, interaction_id TEXT, user_id INTEGER, pickup_year INTEGER, pickup_month INTEGER, pickup_day INTEGER, pickup_type INTEGER)");
			}
		}
	}
	
	static void addUsers(String dbFileName, String[] users) throws Exception {
		
		try (Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbFileName)) {
			for (String user : users) {
				try (PreparedStatement stmt0 = conn.prepareStatement("SELECT * FROM user WHERE email=?")) {
					stmt0.setString(1, user);
					ResultSet rs = stmt0.executeQuery();
					if (rs.next()) {// has element
						System.out.println("User, " + user + ", alredy exists in user table.");
					} else {
						try (PreparedStatement stmt1 =  conn.prepareStatement("INSERT INTO user(email, password) VALUES(?, ?)")) {
							stmt1.setString(1, user);
							stmt1.setString(2, user);
							stmt1.execute();
						}
					}
				}
			}
		}
	}
	
	static String[] getUsersInFile(String fileName) throws Exception {
		List<String> users = new ArrayList<String>();
		try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
			while (true) {
				String line = reader.readLine();
				if (line == null) {
					break;
				}
				String user = line.trim();
				if (user.length() > 0) {
					users.add(user);
				}
			}
			return users.toArray(new String[users.size()]);
		}
	}
}
