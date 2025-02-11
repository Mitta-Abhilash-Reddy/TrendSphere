<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/head.jsp" %>
<%@ include file="includes/navbar.jsp" %>
<%@ page import="cn.tech.Dao.UserDao" %>
<%@ page import="cn.tech.Dao.PostDao" %>
<%@ page import="cn.tech.model.User" %>
<%@ page import="cn.tech.model.Post" %>
<%@ page import="java.util.List" %>

<%
    // Get user ID from request
    String userIdParam = request.getParameter("userId");
    User profileUser = null;
    List<Post> userPosts = null;

    if (userIdParam != null) {
        int userId = Integer.parseInt(userIdParam);
        UserDao userDao = new UserDao();
        PostDao postDao = new PostDao();

        profileUser = userDao.getUserById(userId);
        userPosts = postDao.getPostsByUserId(userId);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <style>
        .profile-card { margin-bottom: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body>
    <div class="container mt-4">
        <% if (profileUser != null) { %>
            <!-- User Info -->
            <div class="card profile-card">
                <div class="card-body">
                    <h3><i class="fas fa-user-circle"></i> <%= profileUser.getUsername() %></h3>
                    <p>Email: <%= profileUser.getEmail() %></p>
                </div>
            </div>

            <!-- User Posts -->
            <h4><%= profileUser.getUsername() %>'s Posts</h4>
            <% if (userPosts != null && !userPosts.isEmpty()) { %>
                <% for (Post post : userPosts) { %>
                    <div class="card post-card mb-3">
                        <div class="card-body">
                            <p><%= post.getContent() %></p>
                            <% if (post.getImagePath() != null && !post.getImagePath().isEmpty()) { %>
                                <img src="post-images/<%= post.getImagePath() %>" alt="Post Image" class="img-fluid">
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <p>No posts yet.</p>
            <% } %>
        <% } else { %>
            <p>User not found.</p>
        <% } %>
    </div>
</body>
</html>
