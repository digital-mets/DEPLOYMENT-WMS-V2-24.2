<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboard2.aspx.cs" Inherits="GWL.IT.frmDashboard2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- App css -->
    <link href="assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/app.min.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Begin page -->
        <div class="wrapper">
            <!-- Start Content-->
            <div class="container-fluid">

                <div class="row mt-3">
                    <div class="col-12">
                        <div class="card widget-inline">
                            <div class="card-body p-0">
                                <div class="row no-gutters">
                                    <div class="col-sm-6 col-xl-3">
                                        <div class="card shadow-none m-0">
                                            <div class="card-body text-center">
                                                <i class="dripicons-briefcase text-muted" style="font-size: 24px;"></i>
                                                <h3><span>29</span></h3>
                                                <p class="text-muted font-15 mb-0">Total SKU</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class="dripicons-checklist text-muted" style="font-size: 24px;"></i>
                                                <h3><span>715</span></h3>
                                                <p class="text-muted font-15 mb-0">Total Batches</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class="dripicons-user-group text-muted" style="font-size: 24px;"></i>
                                                <h3><span>26 out of 31</span></h3>
                                                <p class="text-muted font-15 mb-0">Manpower</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6 col-xl-3">
                                        <div class="card shadow-none m-0 border-left">
                                            <div class="card-body text-center">
                                                <i class="dripicons-graph-line text-muted" style="font-size: 24px;"></i>
                                                <h3><span>93%</span> <i class="mdi mdi-arrow-up text-success"></i></h3>
                                                <p class="text-muted font-15 mb-0">Completion</p>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <!-- end row -->
                            </div>
                        </div>
                        <!-- end card-box-->
                    </div>
                    <!-- end col-->
                </div>
                <!-- end row-->


                <div class="row">
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-4">Project Status</h4>

                                <div class="my-4 chartjs-chart" style="height: 202px;">
                                    <canvas id="project-status-chart" data-colors="#0acf97,#727cf5,#fa5c7c"></canvas>
                                </div>

                                <div class="row text-center mt-2 py-2">
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-up text-success mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span>64%</span>
                                        </h3>
                                        <p class="text-muted mb-0">Completed</p>
                                    </div>
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-down text-primary mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span>26%</span>
                                        </h3>
                                        <p class="text-muted mb-0">In-progress</p>
                                    </div>
                                    <div class="col-4">
                                        <i class="mdi mdi-trending-down text-danger mt-3 h3"></i>
                                        <h3 class="font-weight-normal">
                                            <span>10%</span>
                                        </h3>
                                        <p class="text-muted mb-0">Behind</p>
                                    </div>
                                </div>
                                <!-- end row-->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->

                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Batch Queue</h4>

                                <p><b>657</b> Batch completed out of 715</p>

                                <div class="table-responsive">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Regular  200g</a></h5>
                                                    <span class="text-muted font-13">Batch 1</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Status</span>
                                                    <br />
                                                    <span class="badge badge-warning-lighten">In-progress</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Process Step</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">Mixing</h5>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Progress</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">2/5</h5>
                                                </td>
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Regular  200g</a></h5>
                                                    <span class="text-muted font-13">Batch 2</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Status</span>
                                                    <br />
                                                    <span class="badge badge-danger-lighten">Not Started</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Process Step</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal"></h5>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Progress</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">0/5</h5>
                                                </td>   
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Regular  200g</a></h5>
                                                    <span class="text-muted font-13">Batch 3</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Status</span>
                                                    <br />
                                                    <span class="badge badge-success-lighten">Completed</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Process Step</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">Packing</h5>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Progress</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">5/5</h5>
                                                </td>
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Regular  200g</a></h5>
                                                    <span class="text-muted font-13">Batch 4</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Status</span>
                                                    <br />
                                                    <span class="badge badge-warning-lighten">In-progress</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Process Step</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">Smoke House</h5>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Progress</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">5/5</h5>
                                                </td>
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->
                </div>
                <!-- end row-->


<%--                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-4">Tasks Overview</h4>

                                <div class="mt-3 chartjs-chart" style="height: 320px;">
                                    <canvas id="task-area-chart" data-bgcolor="#727cf5" data-bordercolor="#727cf5"></canvas>
                                </div>

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->
                </div>
                <!-- end row-->


                <div class="row">
                    <div class="col-xl-5">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Recent Activities</h4>

                                <div class="table-responsive">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-2.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Soren Drouin<small class="font-weight-normal ml-3">18 Jan 2019 11:28 pm</small></h5>
                                                            <span class="font-13">Completed "Design new idea"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Project</span>
                                                    <br />
                                                    <p class="mb-0">Hyper Mockup</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-6.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Anne Simard<small class="font-weight-normal ml-3">18 Jan 2019 11:09 pm</small></h5>
                                                            <span class="font-13">Assigned task "Poster illustation design"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Project</span>
                                                    <br />
                                                    <p class="mb-0">Hyper Mockup</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-3.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Nicolas Chartier<small class="font-weight-normal ml-3">15 Jan 2019 09:29 pm</small></h5>
                                                            <span class="font-13">Completed "Drinking bottle graphics"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Project</span>
                                                    <br />
                                                    <p class="mb-0">Web UI Design</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-4.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Gano Cloutier<small class="font-weight-normal ml-3">10 Jan 2019 08:36 pm</small></h5>
                                                            <span class="font-13">Completed "Design new idea"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Project</span>
                                                    <br />
                                                    <p class="mb-0">UBold Admin</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>
                                                    <div class="media">
                                                        <img class="mr-2 rounded-circle" src="assets/images/users/avatar-5.jpg" width="40" alt="Generic placeholder image">
                                                        <div class="media-body">
                                                            <h5 class="mt-0 mb-1">Francis Achin<small class="font-weight-normal ml-3">08 Jan 2019 12:28 pm</small></h5>
                                                            <span class="font-13">Assigned task "Hyper app design"...</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Project</span>
                                                    <br />
                                                    <p class="mb-0">Website Mockup</p>
                                                </td>
                                                <td class="table-action" style="width: 50px;">
                                                    <div class="dropdown">
                                                        <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                                            <i class="mdi mdi-dots-horizontal"></i>
                                                        </a>
                                                        <div class="dropdown-menu dropdown-menu-right">
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                                            <!-- item-->
                                                            <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>
                                <!-- end table-responsive-->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->

                    <div class="col-xl-7">
                        <div class="card">
                            <div class="card-body">
                                <div class="dropdown float-right">
                                    <a href="#" class="dropdown-toggle arrow-none card-drop" data-toggle="dropdown" aria-expanded="false">
                                        <i class="mdi mdi-dots-vertical"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right">
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Weekly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Monthly Report</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Action</a>
                                        <!-- item-->
                                        <a href="javascript:void(0);" class="dropdown-item">Settings</a>
                                    </div>
                                </div>
                                <h4 class="header-title mb-3">Your Calendar</h4>

                                <div class="row">
                                    <div class="col-md-7">
                                        <div data-provide="datepicker-inline" data-date-today-highlight="true" class="calendar-widget"></div>
                                    </div>
                                    <!-- end col-->
                                    <div class="col-md-5">
                                        <ul class="list-unstyled">
                                            <li class="mb-4">
                                                <p class="text-muted mb-1 font-13">
                                                    <i class="mdi mdi-calendar"></i>7:30 AM - 10:00 AM
                                                </p>
                                                <h5>Meeting with BD Team</h5>
                                            </li>
                                            <li class="mb-4">
                                                <p class="text-muted mb-1 font-13">
                                                    <i class="mdi mdi-calendar"></i>10:30 AM - 11:45 AM
                                                </p>
                                                <h5>Design Review - Hyper Admin</h5>
                                            </li>
                                            <li class="mb-4">
                                                <p class="text-muted mb-1 font-13">
                                                    <i class="mdi mdi-calendar"></i>12:15 PM - 02:00 PM
                                                </p>
                                                <h5>Setup Github Repository</h5>
                                            </li>
                                            <li>
                                                <p class="text-muted mb-1 font-13">
                                                    <i class="mdi mdi-calendar"></i>5:30 PM - 07:00 PM
                                                </p>
                                                <h5>Meeting with Design Studio</h5>
                                            </li>
                                        </ul>
                                    </div>
                                    <!-- end col -->
                                </div>
                                <!-- end row -->

                            </div>
                            <!-- end card body-->
                        </div>
                        <!-- end card -->
                    </div>
                    <!-- end col-->

                </div>
                <!-- end row-->--%>


            </div>
            <!-- container -->


        </div>
        <!-- END wrapper -->
    </form>

    <!-- bundle -->
    <script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>

    <!-- third party js -->
    <script src="assets/js/vendor/Chart.bundle.min.js"></script>
    <!-- third party js ends -->

    <!-- demo app -->
    <script src="assets/js/pages/demo.dashboard-projects.js"></script>
    <!-- end demo js-->

</body>
</html>
