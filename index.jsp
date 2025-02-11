<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="includes/head.jsp" %>
<%@ include file="includes/navbar.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.tech.Dao.*" %>
<%@ page import="cn.tech.model.Post" %>
<%@ page import="cn.tech.model.User" %>
<%@ page import="cn.tech.model.Comment" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - Social Media</title>
    <style>
        body { background-color: #f8f9fa; }
        .post-card { margin-bottom: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
        .sidebar { position: sticky; top: 20px; }
        .sidebar .card { margin-bottom: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <!-- Main Feed -->
            <div class="col-md-8">
                <!-- Post Creation Form (Only for Logged-in Users) -->
                <%
                    User loggedInUser = (User) session.getAttribute("user");
                    if (loggedInUser != null) {
                %>
                <div class="card post-card">
                    <div class="card-body">
                        <form action="CreatePostServlet" method="POST" enctype="multipart/form-data">
                            <textarea class="form-control mb-3" name="content" rows="3" placeholder="What's on your mind?"></textarea>
                            <input type="file" class="form-control mb-3" name="image" accept="image/*">
                            <button type="submit" class="btn btn-primary btn-block">Post</button>
                        </form>
                    </div>
                </div>
                <% } %>

                <!-- Feed Posts -->
        
                <%
                PostDao postDAO = new PostDao(); 
                UserDao userDAO = new UserDao(); 
                List<Post> posts = postDAO.getAllPosts();

                for (Post post : posts) {
                    User postUser = userDAO.getUserById(post.getUserId());
                    boolean hasLiked = loggedInUser != null && postDAO.hasUserLikedPost(loggedInUser.getId(), post.getId());
            %>
 // Fetch post owner
               
                <div class="card post-card">
    <div class="card-body">
        <div class="d-flex align-items-center mb-3">
            <img src="https://via.placeholder.com/40" alt="User" class="rounded-circle mr-3">
            <h5 class="mb-0">
    <a href="user.jsp?userId=<%= postUser.getId() %>" class="text-decoration-none">
        <%= postUser.getUsername() %>
    </a>
</h5>

                <small class="text-muted"><%= post.getCreatedAt() %></small>
            </div>
        </div>

        <!-- Add link to post.jsp -->
        <a href="post.jsp?postId=<%= post.getId() %>" class="text-decoration-none text-dark">
            <p><%= post.getContent() %></p>
            <% if (post.getImagePath() != null && !post.getImagePath().isEmpty()) { %>
                <img src="post-images/<%= post.getImagePath() %>" alt="Post Image" class="img-fluid">
            <% } %>
        </a>
    </div>

                    <div class="card-footer">
                       <%
     hasLiked = false;
    if (loggedInUser != null) {
        hasLiked = postDAO.hasUserLikedPost(loggedInUser.getId(), post.getId());
    }
%>

<% if (loggedInUser != null) { %>
    <button class="btn <%= hasLiked ? "btn-primary" : "btn-outline-primary" %> btn-sm like-btn" 
            data-post-id="<%= post.getId() %>">
        <i class="fas fa-thumbs-up"></i> <%= hasLiked ? "Unlike" : "Like" %> 
        (<span class="like-count"><%= post.getLikeCount() %></span>)
    </button>
<% } else { %>
    <button class="btn btn-outline-primary btn-sm" disabled>
        <i class="fas fa-thumbs-up"></i> Like (<span class="like-count"><%= post.getLikeCount() %></span>)
    </button>
<% } %>

                        <button class="btn btn-outline-secondary btn-sm comment-btn"><i class="fas fa-comment"></i> Comment</button>
                        <button class="btn btn-outline-success btn-sm"><i class="fas fa-share"></i> Share</button>
                        <div class="comment-section mt-2" style="display: none;">
    <div class="existing-comments">
        <% 
            CommentDao commentDao = new CommentDao();
            List<Comment> comments = commentDao.getCommentsByPostId(post.getId());
            for (Comment comment : comments) { 
        %>
            <div class="comment">
                <strong><%= comment.getUsername() %></strong>: <%= comment.getContent() %> 
                <small class="text-muted">(<%= comment.getCreatedAt() %>)</small>
            </div>
        <% } %>
    </div>
    <textarea class="form-control mt-2" placeholder="Write a comment..."></textarea>
    <button class="btn btn-sm btn-primary mt-2 post-comment-btn">Post Comment</button>
</div>
                        
                    </div>
                </div>
                <%
                    }
                %>
            </div>

            <!-- Sidebar -->
            <div class="col-md-4">
                <!-- User Info -->
                <div class="card sidebar">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <img src="https://via.placeholder.com/60" alt="User" class="rounded-circle mr-3">
                            <div>
                                <h5 class="mb-0"><%= loggedInUser != null ? loggedInUser.getUsername() : "Guest" %></h5>
                                <small class="text-muted"><%= loggedInUser != null ? "@user" + loggedInUser.getId() : "@guest" %></small>
                            </div>
                        </div>
                        <hr>
                        <% if (loggedInUser == null) { %>
                            <p><a href="login.jsp" class="btn btn-primary btn-block">Login to Post</a></p>
                        <% } %>
                    </div>
                </div>

                <!-- Suggestions -->
                <div class="card sidebar">
                    <div class="card-body">
                        <h5>Suggestions for You</h5>
                        <ul class="list-unstyled">
                            <li class="mb-3">
                                <div class="d-flex align-items-center">
                                    <img src="https://via.placeholder.com/40" alt="User" class="rounded-circle mr-3">
                                    <div>
                                        <h6 class="mb-0">User One</h6>
                                        <small class="text-muted">@userone</small>
                                    </div>
                                    <button class="btn btn-primary btn-sm ml-auto">Follow</button>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        // Toggle comment box
        $(document).on("click", ".comment-btn", function() {
            $(this).siblings(".comment-section").toggle();
        });

        // Post comment event
        $(document).on("click", ".post-comment-btn", function() {
            const postId = $(this).closest(".card-footer").find(".like-btn").data("post-id"); 
            const commentInput = $(this).siblings("textarea");
            const commentText = commentInput.val().trim();
            const commentSection = $(this).closest(".card-footer").find(".comment-section");

            if (commentText === "") {
                alert("Comment cannot be empty!");
                return;
            }

            // Send AJAX request to CommentServlet
            $.post("<%= request.getContextPath() %>/CommentServlet", { postId: postId, comment: commentText }, function(response) {
                if (response.trim() === "Success") {
                    // Append new comment dynamically
                    commentSection.append(`
                        <div class="comment">
                            <strong>You</strong>: ${commentText} <small class="text-muted">(Just now)</small>
                        </div>
                    `);
                    commentInput.val(""); // Clear input
                } else {
                    alert("Error posting comment!");
                }
            });
        });

        // Like button event
        $(document).on("click", ".like-btn", function() {
            const postId = $(this).data("post-id");
            const likeBtn = $(this);
            const likeCountSpan = likeBtn.find(".like-count");

            $.post("<%= request.getContextPath() %>/LikeServlet", { postId: postId }, function(response) {
                if ($.isNumeric(response)) {
                    likeCountSpan.text(response);
                    likeBtn.toggleClass("btn-outline-primary btn-primary");
                    likeBtn.html(`<i class="fas fa-thumbs-up"></i> ` + 
                        (likeBtn.hasClass("btn-primary") ? "Unlike" : "Like") +
                        ` (<span class="like-count">${response}</span>)`);
                } else {
                    alert("Error updating like!");
                }
            });
        });
    });

    </script>
</body>
</html>
