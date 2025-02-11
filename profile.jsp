<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cn.tech.Dao.*" %>
<%@ page import="cn.tech.model.*" %>
<%@ page import="java.util.List" %>
<%@ include file="includes/head.jsp" %>
<%@ include file="includes/navbar.jsp" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    PostDao postDao = new PostDao();
    CommentDao commentDao = new CommentDao();

    List<Post> userPosts = postDao.getPostsByUserId(loggedInUser.getId());  // Fetch user posts
    List<Post> likedPosts = postDao.getLikedPostsByUserId(loggedInUser.getId());  // Fetch liked posts
    List<Comment> userComments = commentDao.getCommentsByUserId(loggedInUser.getId());  // Fetch user comments
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile - <%= loggedInUser.getUsername() %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2><%= loggedInUser.getUsername() %>'s Profile</h2>

    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs" id="profileTabs">
        <li class="nav-item">
            <a class="nav-link active" id="posts-tab" data-bs-toggle="tab" href="#posts">Posts</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="liked-posts-tab" data-bs-toggle="tab" href="#liked-posts">Liked Posts</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="comments-tab" data-bs-toggle="tab" href="#comments">Comments</a>
        </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content mt-3">
        <!-- User Posts -->
        <div class="tab-pane fade show active" id="posts">
            <h4>Your Posts</h4>
            <% for (Post post : userPosts) { %>
                <div class="card mb-3">
                    <div class="card-body">
                        <p><%= post.getContent() %></p>
                        <% if (post.getImagePath() != null && !post.getImagePath().isEmpty()) { %>
                            <img src="post-images/<%= post.getImagePath() %>" class="img-fluid">
                        <% } %>
                        <small class="text-muted">Posted on <%= post.getCreatedAt() %></small>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- Liked Posts -->
        <div class="tab-pane fade" id="liked-posts">
            <h4>Liked Posts</h4>
            <% for (Post post : likedPosts) { %>
                <div class="card mb-3">
                    <div class="card-body">
                        <p><%= post.getContent() %></p>
                        <% if (post.getImagePath() != null && !post.getImagePath().isEmpty()) { %>
                            <img src="post-images/<%= post.getImagePath() %>" class="img-fluid">
                        <% } %>
                        <small class="text-muted">Liked from <%= post.getCreatedAt() %></small>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- User Comments -->
        <div class="tab-pane fade" id="comments">
            <h4>Your Comments</h4>
            <% for (Comment comment : userComments) { %>
                <div class="card mb-3">
                    <div class="card-body">
                        <p><strong>On Post ID <%= comment.getPostId() %>:</strong> <%= comment.getContent() %></p>
                        <small class="text-muted">Commented on <%= comment.getCreatedAt() %></small>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
