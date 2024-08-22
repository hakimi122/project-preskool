<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html lang="en">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
        <title>Add student to exam</title>
        <link rel="shortcut icon" href="./assets/img/favicon.png">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,500;0,600;0,700;1,400&amp;display=swap">
        <link rel="stylesheet" href="./assets/plugins/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" href="./assets/plugins/fontawesome/css/fontawesome.min.css">
        <link rel="stylesheet" href="./assets/plugins/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="./assets/plugins/simple-calendar/simple-calendar.css">
        <link rel="stylesheet" href="./assets/css/style.css">
    </head>
    <body>
        <c:set var="contextPath" value="${pageContext.request.contextPath}" />

        <!-- Notification User -->
        <c:if test="${sessionScope.notification !=null}">
            <div class="alert ${sessionScope.typeNoti} alert-dismissible fade show" role="alert" style="position: fixed; z-index: 15; margin-left: 80%; margin-top: 5%;">
                <strong>${sessionScope.notification}</strong>
            </div>
            <% 
              session.removeAttribute("notification");
              session.removeAttribute("typeNoti");
            %>
        </c:if>
        <div class="main-wrapper">
            <%@include file="header.jsp" %>
            <%@include file="headmasterLeftboard.jsp" %>

            <div class="page-wrapper">
                <div class="content container-fluid">
                    <div class="page-header">
                        <div class="row align-items-center">
                            <div class="col">
                                <h3 class="page-title">Add Student to exam</h3>
                                <h5>Exam Type: ${c.examType} </h5>
                                <h5>Subject: ${c.getSubject().subjectId} - ${c.getSubject().subjectName} </h5>
                                <h5>Slot: ${c.slot.slotId} - ${c.slot.description} </h5>
                                <h5>Teacher In charge: ${c.teacher.userId} - ${c.teacher.fullName} </h5>
                                <h5>Date: ${c.examDate} </h5>
                                <h5>Room: ${c.room} </h5>
                            </div>
                        </div>
                        <div class="row">
                            <a class="btn btn-primary" href="${contextPath}/exam">Back</a>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card card-table">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <form id="addStudentsForm" action="${contextPath}/studentinexam" method="post">
                                            <div class="d-flex justify-content-end">
                                                <input type="submit" class="btn btn-primary" id="saveChangesBtn" value="Save"/>
                                            </div>
                                            <input type="hidden" name="type" value="save"/>
                                            <input type="hidden" name="examId" value="${c.examId}"/>
                                            <input type="hidden" name="examDate" value="${c.examDate}"/>
                                            <input type="hidden" name="slotId" value="${c.slot.slotId}"/>

                                            <table id="teacherTable" class="table table-hover table-center mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Name</th>
                                                        <th>Dob</th>
                                                        <th>Gender</th>
                                                        <th>Email</th>
                                                        <th>Phone</th>
                                                        <th>Choose</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:if test="${students != null}">
                                                        <c:forEach items="${students}" var="t">
                                                            <tr>
                                                                <td>${t.getUserId()}</td>
                                                                <td>${t.getFullName()}</td>
                                                                <td>${t.getDob()}</td>
                                                                <td>${t.getGender()}</td>
                                                                <td>${t.getEmail()}</td>
                                                                <td>${t.getPhone()}</td>
                                                                <td>
                                                                    <div class="actions">
                                                                        <c:set var="isChecked" value="false"/>
                                                                        <c:forEach items="${c.getStudents()}" var="cs">
                                                                            <c:if test="${cs.getUserId() == t.getUserId()}">
                                                                                <c:set var="isChecked" value="true"/>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                        <input type="checkbox" style="width:20px; height:20px" name="selectedStudents" value="${t.getUserId()}" <c:if test="${isChecked}">checked</c:if>>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                        </c:forEach>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="./assets/js/jquery-3.6.0.min.js"></script>
        <script src="./assets/js/popper.min.js"></script>
        <script src="./assets/plugins/bootstrap/js/bootstrap.min.js"></script>
        <script src="./assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
        <script src="./assets/plugins/datatables/datatables.min.js"></script>
        <script src="./assets/js/script.js"></script>

        <script>
            $(document).ready(function () {
                $('#teacherTable').DataTable({
                    "paging": true,
                    "ordering": true,
                    "searching": true,
                    "info": true,
                    "lengthChange": true,
                    "language": {
                        "search": "Search:",
                        "paginate": {
                            "previous": "Previous",
                            "next": "Next"
                        }
                    }
                });
            });

            if (document.querySelector('.alert')) {
                document.querySelectorAll('.alert').forEach(function ($el) {
                    setTimeout(() => {
                        $el.classList.remove('show');
                    }, 3000);
                });
            }
            ;

            $('#saveChangesBtn').click(function () {
                var limit = parseInt($('#limit').val());
                var currentNOS = parseInt($('#currentNOS').val());
                var selectedStudents = $('input[name="selectedStudents"]:checked').length;

                if (currentNOS + selectedStudents > limit) {
                    alert('The number of selected students exceeds the limit.');
                    return false; // Ng?n ch?n vi?c submit form n?u s? l??ng checkbox v??t qu� gi?i h?n
                }
                return true; // Cho ph�p submit form n?u s? l??ng checkbox h?p l?
            });
        </script>
    </body>
</html>