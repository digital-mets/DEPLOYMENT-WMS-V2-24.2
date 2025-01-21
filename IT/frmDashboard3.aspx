<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboard3.aspx.cs" Inherits="GWL.IT.frmDashboard3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- third party css -->
    <link href="assets/css/vendor/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <!-- third party css end -->

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

<%--                <div class="row mt-3">
                    <div class="col-xl-3 col-lg-4">
                        <div class="card tilebox-one">
                            <div class="card-body">
                                <i class='uil uil-users-alt float-right'></i>
                                <h6 class="text-uppercase mt-0">Active Users</h6>
                                <h2 class="my-2" id="active-users-count">121</h2>
                                <p class="mb-0 text-muted">
                                    <span class="text-success mr-2"><span class="mdi mdi-arrow-up-bold"></span>5.27%</span>
                                    <span class="text-nowrap">Since last month</span>
                                </p>
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!--end card-->

                        <div class="card tilebox-one">
                            <div class="card-body">
                                <i class='uil uil-window-restore float-right'></i>
                                <h6 class="text-uppercase mt-0">Views per minute</h6>
                                <h2 class="my-2" id="active-views-count">560</h2>
                                <p class="mb-0 text-muted">
                                    <span class="text-danger mr-2"><span class="mdi mdi-arrow-down-bold"></span>1.08%</span>
                                    <span class="text-nowrap">Since previous week</span>
                                </p>
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!--end card-->

                        <div class="card cta-box overflow-hidden">
                            <div class="card-body">
                                <div class="media align-items-center">
                                    <div class="media-body">
                                        <h3 class="m-0 font-weight-normal cta-box-title">Enhance your <b>Campaign</b> for better outreach <i class="mdi mdi-arrow-right"></i></h3>
                                    </div>
                                    <img class="ml-3" src="assets/images/email-campaign.svg" width="92" alt="Generic placeholder image">
                                </div>
                            </div>
                            <!-- end card-body -->
                        </div>
                    </div>
                    <!-- end col -->

                    <div class="col-xl-9 col-lg-8">
                        <div class="card">
                            <div class="card-body">
                                <div class="alert alert-warning alert-dismissible fade show mb-3" role="alert">
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                    Property HY1xx is not receiving hits. Either your site is not receiving any sessions or it is not tagged correctly.
                                </div>
                                <ul class="nav float-right d-none d-lg-flex">
                                    <li class="nav-item">
                                        <a class="nav-link text-muted" href="#">Today</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link text-muted" href="#">7d</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link active" href="#">15d</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link text-muted" href="#">1m</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link text-muted" href="#">1y</a>
                                    </li>
                                </ul>
                                <h4 class="header-title mb-3">Sessions Overview</h4>

                                <div id="sessions-overview" class="apex-charts mt-3" data-colors="#0acf97"></div>
                            </div>
                            <!-- end card-body-->
                        </div>
                        <!-- end card-->
                    </div>
                </div>


            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="dropdown float-right">
                                <a href="#" class="dropdown-toggle arrow-none card-drop"
                                    data-toggle="dropdown" aria-expanded="false">
                                    <i class="mdi mdi-dots-vertical"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <!-- item-->
                                    <a href="javascript:void(0);" class="dropdown-item">Refresh Report</a>
                                    <!-- item-->
                                    <a href="javascript:void(0);" class="dropdown-item">Export Report</a>
                                </div>
                            </div>
                            <h4 class="header-title">Sessions by country</h4>

                            <div class="row">
                                <div class="col-lg-8">
                                    <div id="world-map-markers" class="mt-3 mb-3" style="height: 300px">
                                    </div>
                                </div>
                                <div class="col-lg-4">
                                    <div id="country-chart" class="apex-charts" data-colors="#727cf5"></div>
                                </div>
                            </div>
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->
            </div>
            <!-- end row -->

            <div class="row">
                <div class="col-xl-4 col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="dropdown float-right">
                                <a href="#" class="dropdown-toggle arrow-none card-drop p-0"
                                    data-toggle="dropdown" aria-expanded="false">
                                    <i class="mdi mdi-dots-vertical"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <a href="javascript:void(0);" class="dropdown-item">Refresh Report</a>
                                    <a href="javascript:void(0);" class="dropdown-item">Export Report</a>
                                </div>
                            </div>
                            <h4 class="header-title">Views Per Minute</h4>

                            <div id="views-min" class="apex-charts mt-2" data-colors="#0acf97"></div>

                            <div class="table-responsive mt-3">
                                <table class="table table-sm mb-0 font-13">
                                    <thead>
                                        <tr>
                                            <th>Page</th>
                                            <th>Views</th>
                                            <th>Bounce Rate</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <a href="javascript:void(0);" class="text-muted">/hyper/dashboard-analytics</a>
                                            </td>
                                            <td>25</td>
                                            <td>87.5%</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="javascript:void(0);" class="text-muted">/hyper/dashboard-crm</a>
                                            </td>
                                            <td>15</td>
                                            <td>21.48%</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="javascript:void(0);" class="text-muted">/ubold/dashboard</a>
                                            </td>
                                            <td>10</td>
                                            <td>63.59%</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="javascript:void(0);" class="text-muted">/minton/home</a>
                                            </td>
                                            <td>7</td>
                                            <td>56.12%</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->

                <div class="col-xl-4 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="dropdown float-right">
                                <a href="#" class="dropdown-toggle arrow-none card-drop p-0"
                                    data-toggle="dropdown" aria-expanded="false">
                                    <i class="mdi mdi-dots-vertical"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <a href="javascript:void(0);" class="dropdown-item">Refresh Report</a>
                                    <a href="javascript:void(0);" class="dropdown-item">Export Report</a>
                                </div>
                            </div>
                            <h4 class="header-title">Sessions by Browser</h4>

                            <div id="sessions-browser" class="apex-charts mt-3" data-colors="#727cf5"></div>
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->

                <div class="col-xl-4 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="dropdown float-right">
                                <a href="#" class="dropdown-toggle arrow-none card-drop p-0"
                                    data-toggle="dropdown" aria-expanded="false">
                                    <i class="mdi mdi-dots-vertical"></i>
                                </a>
                                <div class="dropdown-menu dropdown-menu-right">
                                    <a href="javascript:void(0);" class="dropdown-item">Refresh Report</a>
                                    <a href="javascript:void(0);" class="dropdown-item">Export Report</a>
                                </div>
                            </div>
                            <h4 class="header-title">Sessions by Operating System</h4>

                            <div id="sessions-os" class="apex-charts mt-3" data-colors="#727cf5,#0acf97,#fa5c7c,#ffbc00"></div>

                            <div class="row text-center mt-2">
                                <div class="col-6">
                                    <h4 class="font-weight-normal">
                                        <span>6,510</span>
                                    </h4>
                                    <p class="text-muted mb-0">Online System</p>
                                </div>
                                <div class="col-6">
                                    <h4 class="font-weight-normal">
                                        <span>2,031</span>
                                    </h4>
                                    <p class="text-muted mb-0">Offline System</p>
                                </div>
                            </div>

                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->
            </div>
            <!-- end row -->--%>

            <div class="row mt-3">
                           <div class="col-lg-12">
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
                                <h4 class="header-title mb-3">Product Status</h4>

                                <p><b>657</b> Batch delivered out of 715</p>

                                <div class="table-responsive">
                                    <table class="table table-centered table-nowrap table-hover mb-0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Regular Cheesedog  200g</a></h5>
                                                    <span class="text-muted font-13">200 out of 300 Batches</span>
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
                                                    <span class="text-muted font-13">Completion</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">65%</h5>
                                                </td>
                                                  <td>
                                                     
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-warning" role="progressbar"
                                                        style="width: 65%; height: 20px;" aria-valuenow="65"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                                 </td>
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700032 - Bossing Classic Cheesedog  200g</a></h5>
                                                    <span class="text-muted font-13">0 out of 400 Batches</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Status</span>
                                                    <br />
                                                    <span class="badge badge-danger-lighten">Delayed</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Process Step</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal"></h5>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Completion</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">10%</h5>
                                                </td>  
                                                   <td>
                                                     
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-danger" role="progressbar"
                                                        style="width: 10%; height: 20px;" aria-valuenow="10"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                                 </td>
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Jumbo Cheesedog  200g</a></h5>
                                                    <span class="text-muted font-13">300 out of 300 Batches</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Status</span>
                                                    <br />
                                                    <span class="badge badge-success-lighten">Delivered</span>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Process Step</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">Packing</h5>
                                                </td>
                                                <td>
                                                    <span class="text-muted font-13">Completion</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">100%</h5>
                                                </td>
                                                   <td>
                                                     
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                        style="width: 100%; height: 20px;" aria-valuenow="100"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                                 </td>
                                                <td class="table-action" style="width: 90px;">
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-pencil"></i></a>
                                                    <a href="javascript: void(0);" class="action-icon"><i class="mdi mdi-delete"></i></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <h5 class="font-14 my-1"><a href="javascript:void(0);" class="text-body">7700031 - Bossing Classic Hotdog  200g</a></h5>
                                                    <span class="text-muted font-13">299 out of 300 Batches</span>
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
                                                    <span class="text-muted font-13">Completion</span>
                                                    <h5 class="font-14 mt-1 font-weight-normal">99%</h5>
                                                </td>
                                                   <td>
                                                     
                                                <div class="progress" style="height: 3px;width: 90px;">
                                                    <div class="progress-bar bg-warning" role="progressbar"
                                                        style="width:100%; height: 20px;" aria-valuenow="100"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
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

                <div class="col-xl-4 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <a href="" class="p-0 float-right mb-3">Export <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Machines</h4>

                            <div class="table-responsive">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Machines</th>
                                            <th>Plan vs Avl</th>
                                            <th style="width: 40%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Grinder</td>
                                            <td>4/5</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 65%; height: 20px;" aria-valuenow="65"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Mixer</td>
                                            <td>3/5</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-info" role="progressbar"
                                                        style="width: 45%; height: 20px;" aria-valuenow="45"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Chopper</td>
                                            <td>2/5</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-warning" role="progressbar"
                                                        style="width: 30%; height: 20px;" aria-valuenow="30"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Machine</td>
                                            <td>2/5</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar bg-danger" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- end table-responsive-->
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->

                <div class="col-xl-4 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <a href="" class="p-0 float-right mb-3">Export <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Man power</h4>

                            <div class="table-responsive">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Process Step</th>
                                            <th>Plan vs Actual</th>
                                            <th style="width: 40%;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Grinding</td>
                                            <td>40/50</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 65%; height: 20px;" aria-valuenow="65"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Mixing</td>
                                            <td>10/40</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 45%; height: 20px;" aria-valuenow="45"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Chopping</td>
                                            <td>10/50</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 30%; height: 20px;" aria-valuenow="30"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Smokehouse</td>
                                            <td>10/45</td>
                                            <td>
                                                <div class="progress" style="height: 3px;">
                                                    <div class="progress-bar" role="progressbar"
                                                        style="width: 25%; height: 20px;" aria-valuenow="25"
                                                        aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- end table-responsive-->
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>
                <!-- end col-->

<%--                <div class="col-xl-4 col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <a href="" class="p-0 float-right mb-3">Export <i class="mdi mdi-download ml-1"></i></a>
                            <h4 class="header-title mt-1">Engagement Overview</h4>

                            <div class="table-responsive">
                                <table class="table table-sm table-centered mb-0 font-14">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Duration (Secs)</th>
                                            <th style="width: 30%;">Sessions</th>
                                            <th style="width: 30%;">Views</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>0-30</td>
                                            <td>2,250</td>
                                            <td>4,250</td>
                                        </tr>
                                        <tr>
                                            <td>31-60</td>
                                            <td>1,501</td>
                                            <td>2,050</td>
                                        </tr>
                                        <tr>
                                            <td>61-120</td>
                                            <td>750</td>
                                            <td>1,600</td>
                                        </tr>
                                        <tr>
                                            <td>121-240</td>
                                            <td>540</td>
                                            <td>1,040</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- end table-responsive-->
                        </div>
                        <!-- end card-body-->
                    </div>
                    <!-- end card-->
                </div>--%>
                <!-- end col-->

            </div>
            <!-- end row -->

            </div>
            <!-- container -->


        </div>
        <!-- END wrapper -->
    </form>
    <!-- bundle -->
    <script src="assets/js/vendor.min.js"></script>
    <script src="assets/js/app.min.js"></script>

    <!-- third party js -->
    <!-- <script src="assets/js/vendor/Chart.bundle.min.js"></script> -->
    <script src="assets/js/vendor/apexcharts.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="assets/js/vendor/jquery-jvectormap-world-mill-en.js"></script>
    <!-- third party js ends -->

    <!-- demo app -->
    <script src="assets/js/pages/demo.dashboard-analytics.js"></script>
    <!-- end demo js-->
</body>
</html>
