<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GEARSMainMenu.aspx.cs" Inherits="GWL.MainMenu.GEARSMainMenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>GEARS</title>
    <meta name="description" content="GEARS" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <!--begin::Fonts-->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" />
    <!--end::Fonts-->
    <!--end::Page Vendors Styles-->
    <!--begin::Global Theme Styles(used by all pages)-->
    <link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
    <link href="assets/plugins/custom/prismjs/prismjs.bundle.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/select2.min.css" rel="stylesheet" />
    <!--end::Global Theme Styles-->
    <!--begin::Layout Themes(used by all pages)-->
    <link id="myHeaderBase" href="assets/css/themes/layout/header/base/dark.css" rel="stylesheet" type="text/css" />
    <link id="myHeaderMenu" href="assets/css/themes/layout/header/menu/dark.css" rel="stylesheet" type="text/css" />
    <link id="myLayoutBrand" href="assets/css/themes/layout/brand/dark.css" rel="stylesheet" type="text/css" />
    <link id="myLayoutAside" href="assets/css/themes/layout/aside/dark.css" rel="stylesheet" type="text/css" />
    <!--end::Layout Themes-->

    <!--begin::CSS for Tour-->
    <link rel="stylesheet" href="../Assets/enjoyhint/css/enjoyhint.css" />
    <link rel="stylesheet" href="../Assets/enjoyhint/css/overlay.css" />
    <!--end:: CSS for Tour-->
    <!--begin::CSS for Tour-->
    <%--<link rel="stylesheet" type="text/css" href="../css/DataTable/dataTables.bootstrap4stylesheet.min.css" />--%>
    <%-- <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css" />--%>
    <%--<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css" />--%>
    <!--end:: CSS for Tour-->

    <style>
        .notiftable {
            overflow: auto;
            height: 4vh;
        }

        .bar {
            display: block;
            width: 100%;
            /* content: ''; */
            /* position: absolute; */
            height: 4px;
            border: 1px;
            transition: all .4s;
            -webkit-transition: all .4s;
        }

        .weak {
            width: 33.3% !important;
            background-color: #e74c3c;
        }

        .medium {
            width: 66.6% !important;
            background-color: #e67e22;
        }

        .strong {
            width: 100% !important;
            background-color: #2ecc71;
        }

        .aside-fixed.aside-minimize-hover .brand .brand-logo img {
            display: none !important;
        }

        .aside-fixed.aside-minimize-hover .menu-nav .menu-search {
            display: none !important;
        }

        .aside-fixed.aside-minimize-hover .menu-nav .icon-search {
            margin: auto !important;
            border: none !important;
            padding: 0 !important;
        }

        .aside-fixed.aside-minimize-hover .menu-nav .input-group {
            padding: 0 !important;
        }

        .aside-fixed.aside-minimize-hover .aside .menu-text {
            display: none !important;
        }

        .aside-fixed.aside-minimize-hover .aside {
            width: 70px !important;
        }

        .aside-minimize .aside-menu .menu-nav .menu-search {
            display: none !important;
        }

        .aside-minimize .aside-menu .menu-nav .icon-search {
            margin: auto !important;
            border: none !important;
            padding: 0 !important;
        }

        .aside-minimize .aside-menu .menu-nav .input-group {
            padding: 0 !important;
        }

        #search {
            border-top: 1px solid #E4E6EF !important;
            border-left: 1px solid #E4E6EF !important;
            border-right: none !important;
            border-bottom: 1px solid #E4E6EF !important;
        }

        .icon-search {
            border-top: 1px solid #E4E6EF !important;
            border-left: none !important;
            border-right: 1px solid #E4E6EF !important;
            border-bottom: 1px solid #E4E6EF !important;
        }

        .select2-container--default .select2-selection--single, .select2-selection select2-selection--single {
            height: 45px !important;
        }

            .select2-container--default .select2-selection--single .select2-selection__arrow {
                height: 46px;
            }

        @media (min-width: 992px) {
            .container, .container-fluid, .container-sm, .container-md, .container-lg, .container-xl, .container-xxl {
                padding: 0 10px;
            }

            .aside-minimize-hover .brand {
                -webkit-box-pack: center !important;
                -ms-flex-pack: center !important;
                justify-content: center !important;
            }
        }

        #freshwidget-button {
            display: none !important;
        }

        table.dataTable tbody tr {
            height: 2em !important;
        }

        .notification-container {
            position: fixed;
            top: 86px;
            right: 11px;
            width: 380px;
            border: 0px;
            z-index: 9999;
        }

        .customize {
            opacity: 0;
            height: 0;
            overflow: hidden;
            transition: opacity 1s ease-in-out, height 1s ease-in-out;
        }

        .show.customize {
            opacity: 1;
            height: 120px;
        }

        .showAccept.customize {
            opacity: 1;
            height: 140px;
        }

        #Inboundnotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #28a745;
            color: #fff;
        }

        #Outboundnotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #dc3545;
            color: #fff;
        }

        #Pendingnotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #ffc107;
            color: #fff;
        }

        #NewInboundnotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #fe5001;
            color: #fff;
        }

        #NewOutboundnotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #fe5001;
            color: #fff;
        }

        #CompleteUnloadnotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #28a745;
            color: #fff;
        }

        #CompletePutAwaynotif {
            display: block;
            text-align: center;
            font-size: 18px;
            width: 380px;
            border-radius: 3px;
            border: 0px;
            background-color: #28a745;
            color: #fff;
        }

        .flex-container {
            position: absolute;
            margin-top: 8px;
            margin-left: 14px;
        }

        .flex-item {
            margin: 4px;
        }

        .TestAlign {
            margin-top: 5px;
        }

        .Load-Unload {
            margin-top: 7px;
        }

        .btnclose {
            position: absolute;
            top: 8px;
            right: 8px;
            opacity: 1;
            color: white;
            font-size: 16px;
        }

            .btnclose:hover {
                color: black;
            }

        .contracts {
            max-width: 700px !important;
        }

        #DetailHead2 {
            text-wrap: nowrap !important;
        }

        .PendingAlign {
            padding: 50px 0 50px;
        }
    </style>
</head>
<body id="kt_body" class="header-fixed header-mobile-fixed subheader-enabled subheader-fixed aside-enabled aside-fixed aside-minimize-hoverable page-loading">
    <div id="overlay" onclick="off()">
        <div id="text">
            Welcome to GEARS Toll Processing
            <p style="font-size: 14px;">
                <br />
                1) To facilitate strict recording of Inventory for visibility and accuracy of record

                 <br />
                2) To plan and determining material requirement for forecast of production and schedule

                 <br />
                3) To trace material usage to production

                 <br />
                4) To maximize the capacity and efficiency of production
            </p>

        </div>
    </div>
    <div id="notificationContainerInbound" class="notification-container ">
        <div id="Inboundnotif" class="alert alert-primary customize  d-none"></div>
        <button type="button" id="btnclose1" class="ki ki-close close btnclose d-none"></button>
    </div>
    <div id="notificationContainerOutbound" class="notification-container">
        <div id="Outboundnotif" class="alert alert-primary customize d-none"></div>
        <button type="button" id="btnclose2" class="ki ki-close close btnclose d-none"></button>
    </div>
    <div id="notificationContainerPending" class="notification-container">
        <div id="Pendingnotif" class="alert alert-primary customize d-none"></div>
        <button type="button" id="btnclose3" class="ki ki-close close btnclose d-none"></button>
    </div>
    <div id="notificationContainerNewInbound" class="notification-container ">
        <div id="NewInboundnotif" class="alert alert-primary customize d-none"></div>
        <button type="button" id="btnclose4" class="ki ki-close btnclose close d-none"></button>
    </div>
    <div id="notificationContainerNewOutbound" class="notification-container ">
        <div id="NewOutboundnotif" class="alert alert-primary customize d-none"></div>
        <button type="button" id="btnclose5" class="ki ki-close close btnclose d-none"></button>
    </div>
    <div id="notificationContainerCompleteUnload" class="notification-container ">
        <div id="CompleteUnloadnotif" class="alert alert-primary customize d-none"></div>
        <button type="button" id="btnclose6" class="ki ki-close close btnclose d-none"></button>
    </div>
    <div id="notificationContainerCompletePutAway" class="notification-container ">
        <div id="CompletePutAwaynotif" class="alert alert-primary customize d-none"></div>
        <button type="button" id="btnclose7" class="ki ki-close close btnclose d-none"></button>
    </div>
    <form id="form1" runat="server">

        <!--begin::Header Mobile-->
        <div id="kt_header_mobile" class="header-mobile align-items-center header-mobile-fixed">
            <!--begin::Logo-->
            <a href="#">
                <%--<h3 class="text-muted font-weight-bold">GEARS</h3>--%>
                <img alt="Logo" src="assets/media/logos/logo-light.png" />
            </a>
            <!--end::Logo-->
            <!--begin::Toolbar-->
            <div class="d-flex align-items-center">
                <!--begin::Aside Mobile Toggle-->
                <button class="btn p-0 burger-icon burger-icon-left" id="kt_aside_mobile_toggle">
                    <span></span>
                </button>
                <!--end::Aside Mobile Toggle-->
                <!--begin::Topbar Mobile Toggle-->
                <button type="button" class="btn btn-hover-text-primary p-0 ml-2" id="kt_header_mobile_topbar_toggle">
                    <span class="svg-icon svg-icon-xl">
                        <!--begin::Svg Icon | path:assets/media/svg/icons/General/User.svg-->
                        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                            <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <polygon points="0 0 24 0 24 24 0 24" />
                                <path d="M12,11 C9.790861,11 8,9.209139 8,7 C8,4.790861 9.790861,3 12,3 C14.209139,3 16,4.790861 16,7 C16,9.209139 14.209139,11 12,11 Z" fill="#000000" fill-rule="nonzero" opacity="0.3" />
                                <path d="M3.00065168,20.1992055 C3.38825852,15.4265159 7.26191235,13 11.9833413,13 C16.7712164,13 20.7048837,15.2931929 20.9979143,20.2 C21.0095879,20.3954741 20.9979143,21 20.2466999,21 C16.541124,21 11.0347247,21 3.72750223,21 C3.47671215,21 2.97953825,20.45918 3.00065168,20.1992055 Z" fill="#000000" fill-rule="nonzero" />
                            </g>
                        </svg>
                        <!--end::Svg Icon-->
                    </span>
                </button>
                <!--end::Topbar Mobile Toggle-->
            </div>
            <!--end::Toolbar-->
        </div>
        <!--end::Header Mobile-->
        <div class="d-flex flex-column flex-root">
            <!--begin::Page-->
            <div class="d-flex flex-row flex-column-fluid page">

                <!--begin::Aside-->
                <div class="aside aside-left aside-fixed d-flex flex-column flex-row-auto" id="kt_aside">
                    <!--begin::Brand-->
                    <div class="brand flex-column-auto" id="kt_brand">
                        <!--begin::Logo-->
                        <a href="#" class="brand-logo">
                            <%--<h3 class="text-muted font-weight-bold" id="AbbrCompName_">GEARS</h3>--%>
                            <img alt="Logo" src="assets/media/logos/logo-light.png" />
                        </a>
                        <!--end::Logo-->
                        <!--begin::Toggle-->
                        <button type="button" class="brand-toggle btn btn-sm px-0" id="kt_aside_toggle" onclick="ChangeName(this)">
                            <span class="svg-icon svg-icon svg-icon-xl">
                                <!--begin::Svg Icon | path:assets/media/svg/icons/Navigation/Angle-double-left.svg-->
                                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                        <polygon points="0 0 24 0 24 24 0 24" />
                                        <path d="M5.29288961,6.70710318 C4.90236532,6.31657888 4.90236532,5.68341391 5.29288961,5.29288961 C5.68341391,4.90236532 6.31657888,4.90236532 6.70710318,5.29288961 L12.7071032,11.2928896 C13.0856821,11.6714686 13.0989277,12.281055 12.7371505,12.675721 L7.23715054,18.675721 C6.86395813,19.08284 6.23139076,19.1103429 5.82427177,18.7371505 C5.41715278,18.3639581 5.38964985,17.7313908 5.76284226,17.3242718 L10.6158586,12.0300721 L5.29288961,6.70710318 Z" fill="#000000" fill-rule="nonzero" transform="translate(8.999997, 11.999999) scale(-1, 1) translate(-8.999997, -11.999999)" />
                                        <path d="M10.7071009,15.7071068 C10.3165766,16.0976311 9.68341162,16.0976311 9.29288733,15.7071068 C8.90236304,15.3165825 8.90236304,14.6834175 9.29288733,14.2928932 L15.2928873,8.29289322 C15.6714663,7.91431428 16.2810527,7.90106866 16.6757187,8.26284586 L22.6757187,13.7628459 C23.0828377,14.1360383 23.1103407,14.7686056 22.7371482,15.1757246 C22.3639558,15.5828436 21.7313885,15.6103465 21.3242695,15.2371541 L16.0300699,10.3841378 L10.7071009,15.7071068 Z" fill="#000000" fill-rule="nonzero" opacity="0.3" transform="translate(15.999997, 11.999999) scale(-1, 1) rotate(-270.000000) translate(-15.999997, -11.999999)" />
                                    </g>
                                </svg>
                                <!--end::Svg Icon-->
                            </span>
                        </button>
                        <!--end::Toolbar-->
                    </div>
                    <!--end::Brand-->
                    <!--begin::Aside Menu-->
                    <div class="aside-menu-wrapper flex-column-fluid" id="kt_aside_menu_wrapper">
                        <!--begin::Menu Container-->


                        <div id="kt_aside_menu" class="aside-menu my-4" data-menu-vertical="1" data-menu-scroll="1" data-menu-dropdown-timeout="500">

                            <!--begin::Menu Nav-->
                            <!--end::Menu Nav-->
                        </div>
                        <!--end::Menu Container-->
                    </div>
                    <!--end::Aside Menu-->
                </div>
                <!--end::Aside-->
                <!--begin::Wrapper-->
                <div class="d-flex flex-column flex-row-fluid wrapper" style="padding-top: 60px" id="kt_wrapper">
                    <!--begin::Header-->
                    <div id="kt_header" class="header header-fixed">
                        <!--begin::Container-->
                        <div class="container-fluid d-flex align-items-stretch justify-content-between">
                            <!--begin::Header Menu Wrapper-->
                            <div class="header-menu-wrapper header-menu-wrapper-left" id="kt_header_menu_wrapper">
                                <!--begin::Header Menu-->
                                <div id="kt_header_menu" class="header-menu header-menu-mobile header-menu-layout-default">
                                    <!--begin::Header Nav-->
                                    <div class="menu-nav">
                                        <div class="menu-item menu-item-open menu-item-here menu-item-submenu menu-item-rel menu-item-open menu-item-here menu-item-active" data-menu-toggle="click" aria-haspopup="true">
                                            <a href="javascript:;" class="menu-link menu-toggle">
                                                <span class="menu-text" runat="server" id="txtCompanyName"></span>
                                            </a>
                                        </div>
                                    </div>
                                    <!--end::Header Nav-->
                                </div>
                                <!--end::Header Menu-->
                            </div>
                            <!--end::Header Menu Wrapper-->
                            <!--begin::Topbar-->
                            <div class="topbar">

                                <!--begin::Notifications-->
                                <div class="dropdown">
                                    <!--begin::Toggle-->
                                    <div class="topbar-item" data-toggle="modal" data-target="#Contract" onclick="Contracts()">
                                        <div class="btn btn-icon btn-clean btn-dropdown btn-lg mr-1 pulse pulse-primary">
                                            <span class="svg-icon svg-icon-xl svg-icon-primary">
                                                <!--begin::Svg Icon | path:assets/media/svg/icons/Code/Compiling.svg-->
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="color: rgb(54,153,255);">
                                                    <path d="M20 4H13L11 2H4C2.897 2 2 2.897 2 4v16c0 1.103.897 2 2 2h16c1.103 0 2-0.897 2-2V6C22 4.897 21.103 4 20 4zM20 20H4V4h2v7h12V4h2v16z" fill="#3699ff" />
                                                </svg>
                                                <!--end::Svg Icon-->
                                            </span>
                                            <span class="pulse-ring"></span>
                                        </div>
                                    </div>
                                    <!--end::Toggle-->
                                </div>
                                <!--end::Notifications-->

                                <!--begin::Notifications-->
                                <div class="dropdown">
                                    <!--begin::Toggle-->
                                    <div class="topbar-item" data-toggle="modal" data-target="#Notification" onclick="NotifyMe()">
                                        <div class="btn btn-icon btn-clean btn-dropdown btn-lg mr-1 pulse pulse-primary">
                                            <span class="svg-icon svg-icon-xl svg-icon-primary">
                                                <!--begin::Svg Icon | path:assets/media/svg/icons/Code/Compiling.svg-->
                                                <svg style="color: rgb(54,153,255);" width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                    <path d="M12 22C10.8954 22 10 21.1046 10 20H14C14 21.1046 13.1046 22 12 22ZM20 19H4V17L6 16V10.5C5.94732 9.0891 6.26594 7.68911 6.924 6.43998C7.57904 5.2815 8.6987 4.45886 10 4.17998V1.99998H13.646C12.3464 3.45242 12.1295 5.57638 13.1087 7.26153C14.0879 8.94667 16.0406 9.80992 17.946 9.39998C17.981 9.75698 17.998 10.127 17.998 10.5V16L19.998 17V19H20ZM17 7.99998C15.4097 7.99752 14.0977 6.75453 14.0093 5.16671C13.9209 3.57888 15.0869 2.19797 16.6671 2.01904C18.2473 1.8401 19.6926 2.92533 19.9615 4.49271C20.2304 6.0601 19.2295 7.56499 17.68 7.92298C17.457 7.97421 17.2288 8.00004 17 7.99998Z" fill="#3699ff"></path>
                                                </svg>
                                                <!--end::Svg Icon-->
                                            </span>
                                            <span class="pulse-ring"></span>
                                        </div>
                                    </div>
                                    <!--end::Toggle-->
                                </div>
                                <!--end::Notifications-->

                                <!--begin::Notifications-->
                                <div class="dropdown d-none">
                                    <!--begin::Toggle-->
                                    <div class="topbar-item" data-toggle="modal" data-target="#changeDefaultWHSModal" onclick="GetDropdownEmp()">
                                        <div class="btn btn-icon btn-clean btn-dropdown btn-lg mr-1 pulse pulse-primary">
                                            <span class="svg-icon svg-icon-xl svg-icon-primary">
                                                <!--begin::Svg Icon | path:assets/media/svg/icons/Code/Compiling.svg-->
                                                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                                                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"> ../icons/
                                                        <rect x="0" y="0" width="24" height="24"></rect>
                                                        <path d="M4,9.67471899 L10.880262,13.6470401 C10.9543486,13.689814 11.0320333,13.7207107 11.1111111,13.740321 L11.1111111,21.4444444 L4.49070127,17.526473 C4.18655139,17.3464765 4,17.0193034 4,16.6658832 L4,9.67471899 Z M20,9.56911707 L20,16.6658832 C20,17.0193034 19.8134486,17.3464765 19.5092987,17.526473 L12.8888889,21.4444444 L12.8888889,13.6728275 C12.9050191,13.6647696 12.9210067,13.6561758 12.9368301,13.6470401 L20,9.56911707 Z" fill="#000000"></path>
                                                        <path d="M4.21611835,7.74669402 C4.30015839,7.64056877 4.40623188,7.55087574 4.5299008,7.48500698 L11.5299008,3.75665466 C11.8237589,3.60013944 12.1762411,3.60013944 12.4700992,3.75665466 L19.4700992,7.48500698 C19.5654307,7.53578262 19.6503066,7.60071528 19.7226939,7.67641889 L12.0479413,12.1074394 C11.9974761,12.1365754 11.9509488,12.1699127 11.9085461,12.2067543 C11.8661433,12.1699127 11.819616,12.1365754 11.7691509,12.1074394 L4.21611835,7.74669402 Z" fill="#000000" opacity="0.3"></path>                    
                                                    </g>
                                                </svg>
                                                <!--end::Svg Icon-->
                                            </span>
                                            <span class="pulse-ring"></span>
                                        </div>
                                    </div>
                                    <!--end::Toggle-->
                                </div>
                                <!--end::Notifications-->
                                <!--begin::Quick Actions-->
                                <div class="dropdown d-none">
                                    <!--begin::Toggle-->
                                    <div class="topbar-item" data-toggle="modal" data-target="#changeWorkDateModal">
                                        <div class="btn btn-icon btn-clean btn-dropdown btn-lg mr-1 pulse pulse-primary">
                                            <span class="svg-icon svg-icon-xl svg-icon-primary">
                                                <!--begin::Svg Icon | path:assets/media/svg/icons/Media/Equalizer.svg-->
                                                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                                                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                        <polygon points="0 0 24 0 24 24 0 24"></polygon>
                                                        <path d="M18.5,8 C17.1192881,8 16,6.88071187 16,5.5 C16,4.11928813 17.1192881,3 18.5,3 C19.8807119,3 21,4.11928813 21,5.5 C21,6.88071187 19.8807119,8 18.5,8 Z M18.5,21 C17.1192881,21 16,19.8807119 16,18.5 C16,17.1192881 17.1192881,16 18.5,16 C19.8807119,16 21,17.1192881 21,18.5 C21,19.8807119 19.8807119,21 18.5,21 Z M5.5,21 C4.11928813,21 3,19.8807119 3,18.5 C3,17.1192881 4.11928813,16 5.5,16 C6.88071187,16 8,17.1192881 8,18.5 C8,19.8807119 6.88071187,21 5.5,21 Z" fill="#000000" opacity="0.3"></path>
                                                        <path d="M5.5,8 C4.11928813,8 3,6.88071187 3,5.5 C3,4.11928813 4.11928813,3 5.5,3 C6.88071187,3 8,4.11928813 8,5.5 C8,6.88071187 6.88071187,8 5.5,8 Z M11,4 L13,4 C13.5522847,4 14,4.44771525 14,5 C14,5.55228475 13.5522847,6 13,6 L11,6 C10.4477153,6 10,5.55228475 10,5 C10,4.44771525 10.4477153,4 11,4 Z M11,18 L13,18 C13.5522847,18 14,18.4477153 14,19 C14,19.5522847 13.5522847,20 13,20 L11,20 C10.4477153,20 10,19.5522847 10,19 C10,18.4477153 10.4477153,18 11,18 Z M5,10 C5.55228475,10 6,10.4477153 6,11 L6,13 C6,13.5522847 5.55228475,14 5,14 C4.44771525,14 4,13.5522847 4,13 L4,11 C4,10.4477153 4.44771525,10 5,10 Z M19,10 C19.5522847,10 20,10.4477153 20,11 L20,13 C20,13.5522847 19.5522847,14 19,14 C18.4477153,14 18,13.5522847 18,13 L18,11 C18,10.4477153 18.4477153,10 19,10 Z" fill="#000000"></path>
                                                    </g>
                                                </svg>
                                                <!--end::Svg Icon-->
                                            </span>
                                            <span class="pulse-ring"></span>
                                        </div>
                                    </div>
                                    <!--end::Toggle-->
                                </div>
                                <!--end::Quick Actions-->
                                <!--begin::Quick panel-->
                                <div class="topbar-item">
                                    <div class="btn btn-icon btn-clean btn-lg mr-1" id="kt_quick_panel_toggle">
                                        <span class="svg-icon svg-icon-xl svg-icon-primary">
                                            <!--begin::Svg Icon | path:assets/media/svg/icons/Layout/Layout-4-blocks.svg-->
                                            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                                                <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                    <rect x="0" y="0" width="24" height="24"></rect>
                                                    <rect fill="#000000" x="4" y="4" width="7" height="7" rx="1.5"></rect>
                                                    <path d="M5.5,13 L9.5,13 C10.3284271,13 11,13.6715729 11,14.5 L11,18.5 C11,19.3284271 10.3284271,20 9.5,20 L5.5,20 C4.67157288,20 4,19.3284271 4,18.5 L4,14.5 C4,13.6715729 4.67157288,13 5.5,13 Z M14.5,4 L18.5,4 C19.3284271,4 20,4.67157288 20,5.5 L20,9.5 C20,10.3284271 19.3284271,11 18.5,11 L14.5,11 C13.6715729,11 13,10.3284271 13,9.5 L13,5.5 C13,4.67157288 13.6715729,4 14.5,4 Z M14.5,13 L18.5,13 C19.3284271,13 20,13.6715729 20,14.5 L20,18.5 C20,19.3284271 19.3284271,20 18.5,20 L14.5,20 C13.6715729,20 13,19.3284271 13,18.5 L13,14.5 C13,13.6715729 13.6715729,13 14.5,13 Z" fill="#000000" opacity="0.3"></path>
                                                </g>
                                            </svg>
                                            <!--end::Svg Icon-->
                                        </span>
                                    </div>
                                </div>
                                <!--end::Quick panel-->
                                <!--begin::User-->
                                <div class="topbar-item">
                                    <div class="btn btn-icon btn-icon-mobile w-auto btn-clean d-flex align-items-center btn-lg px-2" id="kt_quick_user_toggle">
                                        <span class="text-muted font-weight-bold font-size-base d-none d-md-inline mr-1">Hi,</span>
                                        <span runat="server" id="txtFirstName" class="text-dark-50 font-weight-bolder font-size-base d-none d-md-inline mr-3">Nats</span>
                                        <span runat="server" id="txtNameAbbr" class="symbol symbol-lg-35 symbol-25 symbol-light-success">
                                            <span class="symbol-label font-size-h5 font-weight-bold">S</span>
                                        </span>
                                    </div>
                                </div>
                                <!--end::User-->
                            </div>
                            <!--end::Topbar-->
                        </div>
                        <!--end::Container-->
                    </div>
                    <!--end::Header-->
                    <!--begin::Content-->
                    <div class="content d-flex flex-column flex-column-fluid" id="kt_content">
                        <!--begin::Entry-->
                        <div class="d-flex flex-column-fluid">
                            <!--begin::Container-->
                            <div class="container-fluid">
                                <!--begin::Dashboard-->
                                <iframe id="MyFrame" src="../IT/frmDashboard.aspx" name="iframe_a"
                                    style="border: 0px; width: 100%; overflow: hidden; padding: 0px; margin-bottom: -8px; background: #fff; box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);"></iframe>
                                <!--end::Dashboard-->
                            </div>
                            <!--end::Container-->
                        </div>
                        <!--end::Entry-->
                    </div>
                    <!--end::Content-->
                </div>
                <!--end::Wrapper-->
            </div>
            <!--end::Page-->
        </div>
        <!--end::Main-->
        <!-- begin::User Panel-->
        <div id="kt_quick_user" class="offcanvas offcanvas-right p-10">
            <!--begin::Header-->
            <div class="offcanvas-header d-flex align-items-center justify-content-between pb-5">
                <h3 class="font-weight-bold m-0">User Profile
				<small class="text-muted font-size-sm ml-2"></small></h3>
                <a href="#" class="btn btn-xs btn-icon btn-light btn-hover-primary" id="kt_quick_user_close">
                    <i class="ki ki-close icon-xs text-muted"></i>
                </a>
            </div>
            <!--end::Header-->
            <!--begin::Content-->
            <div class="offcanvas-content pr-4 mr-n4">
                <!--begin::Header-->
                <div class="d-flex align-items-center mt-5">
                    <div class="symbol symbol-100 mr-5">
                        <div class="symbol-label" runat="server" id="UserImage"></div>
                        <i class="symbol-badge bg-success"></i>
                    </div>
                    <div class="d-flex flex-column">
                        <label class="font-weight-bold font-size-h6 text-dark-75 text-hover-primary" runat="server" id="txtFullName">Renato A. Anciado Jr.</label>
                        <div runat="server" id="txtRole" class="text-muted mt-1">Software Developer</div>
                        <div class="navi mt-2">
                            <a href="#" class="navi-item">
                                <span class="navi-link p-0 pb-2">
                                    <span class="navi-icon mr-1">
                                        <span class="svg-icon svg-icon-lg svg-icon-primary">
                                            <!--begin::Svg Icon | path:assets/media/svg/icons/Communication/Mail-notification.svg-->
                                            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                                                <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                    <rect x="0" y="0" width="24" height="24" />
                                                    <path d="M21,12.0829584 C20.6747915,12.0283988 20.3407122,12 20,12 C16.6862915,12 14,14.6862915 14,18 C14,18.3407122 14.0283988,18.6747915 14.0829584,19 L5,19 C3.8954305,19 3,18.1045695 3,17 L3,8 C3,6.8954305 3.8954305,6 5,6 L19,6 C20.1045695,6 21,6.8954305 21,8 L21,12.0829584 Z M18.1444251,7.83964668 L12,11.1481833 L5.85557487,7.83964668 C5.4908718,7.6432681 5.03602525,7.77972206 4.83964668,8.14442513 C4.6432681,8.5091282 4.77972206,8.96397475 5.14442513,9.16035332 L11.6444251,12.6603533 C11.8664074,12.7798822 12.1335926,12.7798822 12.3555749,12.6603533 L18.8555749,9.16035332 C19.2202779,8.96397475 19.3567319,8.5091282 19.1603533,8.14442513 C18.9639747,7.77972206 18.5091282,7.6432681 18.1444251,7.83964668 Z" fill="#000000" />
                                                    <circle fill="#000000" opacity="0.3" cx="19.5" cy="17.5" r="2.5" />
                                                </g>
                                            </svg>
                                            <!--end::Svg Icon-->
                                        </span>
                                    </span>
                                    <span runat="server" id="txtCompanyEmail" class="navi-text text-muted text-hover-primary">renato.anciado@mets.ph</span>
                                </span>
                            </a>
                            <%--<asp:Button ID="Button1" Text="Sign Out" OnClick="btnSignOut_Click" runat="server" CssClass="btn btn-sm btn-light-primary font-weight-bolder py-2 px-5" />--%>
                        </div>
                    </div>
                </div>
                <div class="d-flex flex-column">
                    <%--<button id="btnChangeSite" type="button" class="btn btn-sm btn-light-info font-weight-bolder py-2 px-5 my-3">Change Site</button>--%>
                    <asp:Button ID="btnChangeSite" Text="Change Site" UseSubmitBehavior="false" OnClick="btnChangeSite_Click" runat="server" CssClass="btn btn-sm btn-light-info font-weight-bolder py-2 px-5 my-3" />
                    <%--<asp:Button ID="Button2" Text="Change Site" OnClick="btnChangeSite_Click" runat="server" CssClass="btn btn-sm btn-light-info font-weight-bolder py-2 px-5 my-3" />--%>
                    <asp:Button ID="Button1" Text="Sign Out" UseSubmitBehavior="false" OnClick="btnSignOut_Click" runat="server" CssClass="btn btn-sm btn-light-danger font-weight-bolder py-2 px-5 " />
                </div>
                <!--end::Header-->
                <!--begin::Separator-->
                <div class="separator separator-dashed mt-8 mb-5"></div>
                <!--end::Separator-->
                <!--begin::Nav-->
                <button id="getEmail" type="button" data-toggle="modal" data-target="#updateEmailModal" class="btn btn-sm btn-light-primary font-weight-bolder py-2 px-5 mb-3 col-12" runat="server">Update Email</button>
                <button type="button" data-toggle="modal" data-target="#changePasswordModal" class="btn btn-sm btn-light-warning font-weight-bolder py-2 px-5 mb-3 col-12">Change Password</button>
                <button id="btnPin" type="button" data-toggle="modal" data-target="#changePinModal" class="btn btn-sm btn-light-info font-weight-bolder py-2 px-5 mb-3 col-12">Set Pin</button>
                <a href="#" onclick="FreshWidget.show(); return false;" type="button" class="btn btn-sm btn-light-success font-weight-bolder py-2 px-5 mb-3 col-12">Contact Support</a>

                <div class="navi navi-spacer-x-0 p-0">
                    <!--begin::Item-->
                    <div class="navi-item">
                        <div class="navi-link">
                            <div class="navi-text">
                                <div class="font-weight-bold">Software:</div>
                                <div class="text-muted">
                                    Generic Enterprise Advance Resource Solutions
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--end:Item-->
                    <!--begin::Item-->
                    <div class="navi-item">
                        <div class="navi-link">
                            <div class="navi-text">
                                <div class="font-weight-bold">Version Build:</div>
                                <div class="text-muted">GEARS ver 2.20201118</div>
                            </div>
                        </div>
                    </div>
                    <!--end:Item-->
                </div>
                <!--end::Nav-->
            </div>
            <!--end::Content-->
        </div>
        <!-- end::User Panel-->

        <!--begin::Quick Panel-->
        <div id="kt_quick_panel" class="offcanvas offcanvas-right pt-5 pb-10">
            <!--begin::Header-->
            <div class="offcanvas-header offcanvas-header-navs d-flex align-items-center justify-content-between mb-5" kt-hidden-height="44" style="">
                <ul class="nav nav-bold nav-tabs nav-tabs-line nav-tabs-line-3x nav-tabs-primary flex-grow-1 px-10" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#kt_quick_panel_logs">Themes</a>
                    </li>
                </ul>
                <div class="offcanvas-close mt-n1 pr-5">
                    <a href="#" class="btn btn-xs btn-icon btn-light btn-hover-primary" id="kt_quick_panel_close">
                        <i class="ki ki-close icon-xs text-muted"></i>
                    </a>
                </div>
            </div>
            <!--end::Header-->
            <!--begin::Content-->
            <div class="offcanvas-content px-10">
                <div class="tab-content">
                    <!--begin::Tabpane-->
                    <div class="tab-pane fade show pt-3 pr-5 mr-n5 active scroll ps ps--active-y" id="kt_quick_panel_logs" role="tabpanel" style="height: 525px; overflow: hidden;">
                        <!--begin::Section-->
                        <div class="mb-15">
                            <h5 class="font-weight-bold mb-5">Choose Theme</h5>
                            <!--begin::Item-->
                            <div class="d-flex align-items-center flex-wrap mb-5">
                                <div class="tab-content pt-3">
                                    <!--begin::Tab Pane-->
                                    <div class="tab-pane active" id="kt_builder_themes">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label text-lg-right">Header Theme:</label>
                                            <div class="col-sm-9">
                                                <select class="form-control form-control-solid" id="selHeaderBase">
                                                    <option value="dark" selected="selected">Dark(default)</option>
                                                    <option value="light">Light</option>
                                                </select>
                                                <div class="form-text text-muted">Select header theme</div>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label text-lg-right">Header Menu Theme:</label>
                                            <div class="col-sm-9">
                                                <select class="form-control form-control-solid" id="selHeaderMenu">
                                                    <option value="dark" selected="selected">Dark(default)</option>
                                                    <option value="light">Light</option>
                                                </select>
                                                <div class="form-text text-muted">Select header theme</div>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label text-lg-right">Logo Bar Theme:</label>
                                            <div class="col-sm-9">
                                                <select class="form-control form-control-solid" id="selLayoutBrand">
                                                    <option value="dark" selected="selected">Dark(default)</option>
                                                    <option value="light">Light</option>
                                                </select>
                                                <div class="form-text text-muted">Select logo bar theme</div>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label text-lg-right">Aside Theme:</label>
                                            <div class="col-sm-9">
                                                <select class="form-control form-control-solid" id="selLayoutAside">
                                                    <option value="light" selected="selected">Light</option>
                                                    <option value="dark" selected="selected">Dark(default)</option>
                                                </select>
                                                <div class="form-text text-muted">Select left aside theme</div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--end::Tab Pane-->
                                </div>
                            </div>
                            <!--end::Item-->
                            <!--begin::Item-->
                            <div class="d-flex align-items-center flex-wrap">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <button type="button" onclick="ChangeStyle()" class="btn btn-primary font-weight-bold mr-2">Change</button>
                                        <button type="button" onclick="ResetStyle()" class="btn btn-clean font-weight-bold">Reset</button>
                                    </div>
                                </div>
                            </div>
                            <!--end::Item-->
                        </div>
                        <!--end::Section-->
                        <div class="ps__rail-x" style="left: 0px; bottom: 0px;">
                            <div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div>
                        </div>
                        <div class="ps__rail-y" style="top: 0px; height: 525px; right: 0px;">
                            <div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 300px;"></div>
                        </div>
                    </div>
                    <!--end::Tabpane-->
                </div>
            </div>
            <!--end::Content-->
        </div>
        <!--end::Quick Panel-->
        <!--begin::Scrolltop-->
        <div id="kt_scrolltop" class="scrolltop">
            <span class="svg-icon">
                <!--begin::Svg Icon | path:assets/media/svg/icons/Navigation/Up-2.svg-->
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                        <polygon points="0 0 24 0 24 24 0 24" />
                        <rect fill="#000000" opacity="0.3" x="11" y="10" width="2" height="10" rx="1" />
                        <path d="M6.70710678,12.7071068 C6.31658249,13.0976311 5.68341751,13.0976311 5.29289322,12.7071068 C4.90236893,12.3165825 4.90236893,11.6834175 5.29289322,11.2928932 L11.2928932,5.29289322 C11.6714722,4.91431428 12.2810586,4.90106866 12.6757246,5.26284586 L18.6757246,10.7628459 C19.0828436,11.1360383 19.1103465,11.7686056 18.7371541,12.1757246 C18.3639617,12.5828436 17.7313944,12.6103465 17.3242754,12.2371541 L12.0300757,7.38413782 L6.70710678,12.7071068 Z" fill="#000000" fill-rule="nonzero" />
                    </g>
                </svg>
                <!--end::Svg Icon-->
            </span>
        </div>

        <div class="modal fade" id="Contract" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true" style="height: 48vh;">
            <div class="modal-dialog contracts" role="document">
                <div class="modal-content" style="left: 17vw; max-height: 80%;">
                    <div class="modal-header" style="padding: 10px 0px 0px 10px">
                        <h5 class="modal-title" id="AllContract">Contracts</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close" style="margin-right: 10px"></i>
                        </button>
                    </div>
                    <div class="modal-body" style="padding: 0;">
                        <div class="table-responsive">
                            <div class="table-responsive" style="overflow: hidden;">
                                <table id="Contracttable" class="table dt-responsive table-nowrap w-700 table-striped notiftable " style="padding: 0; width: 0px"></table>
                            </div>
                        </div>
                    </div>
                    <%--<div class="modal-footer">
                        <button type="button" id="btnChangeDefaultWHS" onclick="SetSession('submitwh')" class="btn btn-primary font-weight-bold">Submit</button>
                    </div>--%>
                </div>
            </div>
        </div>

        <div class="modal fade" id="Notification" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true" style="height: 50vh;">
            <div class="modal-dialog modal-dialog-scrollable" role="document">
                <div class="modal-content" style="left: 20vw; max-height: 100%;">
                    <div class="modal-header " style="padding: 10px 0px 0px 10px">
                        <h5 class="modal-title" id="AllNotification">Notifications</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close" style="margin-right: 10px"></i>
                        </button>
                    </div>
                    <div class="modal-body" style="padding: 0;">
                        <div class="table-responsive">
                            <div class="table-responsive" style="overflow: hidden;">
                                <table id="Notificationtable" class="table dt-responsive table-nowrap w-200 table-striped notiftable " style="padding: 0;"></table>
                            </div>
                        </div>
                    </div>
                    <%--<div class="modal-footer">
                        <button type="button" id="btnChangeDefaultWHS" onclick="SetSession('submitwh')" class="btn btn-primary font-weight-bold">Submit</button>
                    </div>--%>
                </div>
            </div>
        </div>

        <div class="modal fade" id="changeDefaultWHSModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Change Default Warehouse</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="col-sm-12 col-form-label text-lg-left">WarehouseCode:</label>
                            <div class="col-sm-12">
                                <select class="form-control" id="selWarehouseCode">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnChangeDefaultWHS" onclick="SetSession('submitwh')" class="btn btn-primary font-weight-bold">Submit</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="changeWorkDateModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="changeWorkDateModalLabel">Change Work Date</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="col-sm-12 col-form-label text-lg-left">Work Date:</label>
                            <div class="col-sm-12">
                                <input class="form-control" type="date" value="2011-08-19" id="txtWorkDate" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnChangeWorkDate" onclick="SetSession('submitwd')" class="btn btn-primary font-weight-bold">Submit</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="updateEmailModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
            <div class="modal-dialog modal-md" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateEmailModalLabel">Update Email</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Email Address:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="email" id="txtEmail" name="txtEmail" class="form-control1" placeholder="Email Address" aria-describedby="basic-addon2" runat="server" value="" />
                                    <input type="hidden" name="hiddentxtEmail" id="hiddentxtEmail" runat="server" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-envelope"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Password:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="password" id="txtPassword" name="txtPassword" class="form-control" placeholder="Password" aria-describedby="basic-addon2" runat="server" value="" />
                                    <input type="hidden" name="hiddentxtPassword" id="hiddentxtPassword" runat="server" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-key"></i>
                                        </span>
                                    </div>
                                </div>
                                <div class="bar"></div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Host:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="text" id="txtHost" name="txtHost" class="form-control" placeholder="Host" aria-describedby="basic-addon2" runat="server" value="" />
                                    <input type="hidden" name="hiddentxtPort" id="hiddentxtPort" runat="server" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-database"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Port:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="text" id="txtPort" name="txtPort" class="form-control" placeholder="Port" aria-describedby="basic-addon2" runat="server" value="" />
                                    <input type="hidden" name="hiddentxtHost" id="hiddentxtHost" runat="server" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-commenting"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnUpdateEmail" class="btn btn-primary font-weight-bold">Update Email</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="supportModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
            <div class="modal-dialog modal-md" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="supportModalLabel">Help & Support</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                    </div>
                    <%--<div class="modal-footer">
                        <button type="button" id="btnUpdateEmail" class="btn btn-primary font-weight-bold">Update Email</button>
                    </div>--%>
                </div>
            </div>
        </div>

        <div class="modal fade" id="changePasswordModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
            <div class="modal-dialog modal-md" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="changePasswordModalLabel">Change Password</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <i aria-hidden="true" class="ki ki-close"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Enter Password:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="password" id="txtOldPassword" class="form-control" placeholder="Password" aria-describedby="basic-addon2" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-key"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Enter New Password:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="password" id="txtNewPassword" class="form-control" placeholder="New Password" aria-describedby="basic-addon2" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-key"></i>
                                        </span>
                                    </div>
                                </div>
                                <div class="bar"></div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label class="col-sm-4 col-form-label text-lg-left">Re-enter Password:</label>
                            <div class="col-sm-8">
                                <div class="input-group input-group-sm">
                                    <input type="password" id="txtREnPassword" class="form-control" placeholder="Re-enter Password" aria-describedby="basic-addon2" />
                                    <div class="input-group-append">
                                        <span class="input-group-text">
                                            <i class="la la-key"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnChangePass" onclick="ChangePass(this)" class="btn btn-primary font-weight-bold">Submit</button>
                    </div>
                </div>
            </div>
        </div>

         <div class="modal fade" id="setPinModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
            <div class="modal-dialog modal-md" role="document">
             <div class="modal-content">
                 <div class="modal-header">
                     <h5 class="modal-title" id="setPinModalLabel">Set PIN</h5>
                     <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                         <i aria-hidden="true" class="ki ki-close"></i>
                     </button>
                 </div>
                 <div class="modal-body">
                     <div class="form-group row">
                         <label class="col-sm-4 col-form-label text-lg-left">Enter PIN:</label>
                         <div class="col-sm-8">
                             <div class="input-group input-group-sm">
                                 <input type="password" id="txtSetPin" class="form-control" placeholder="PIN" aria-describedby="basic-addon2" />
                                 <div class="input-group-append">
                                     <span class="input-group-text">
                                         <i class="la la-key"></i>
                                     </span>
                                 </div>
                             </div>
                         </div>
                     </div>
                     <div class="form-group row">
                         <label class="col-sm-4 col-form-label text-lg-left">Re-enter PIN:</label>
                         <div class="col-sm-8">
                             <div class="input-group input-group-sm">
                                 <input type="password" id="txtSetREnPin" class="form-control" placeholder="Re-enter PIN" aria-describedby="basic-addon2" />
                                 <div class="input-group-append">
                                     <span class="input-group-text">
                                         <i class="la la-key"></i>
                                     </span>
                                 </div>
                             </div>
                         </div>
                     </div>
                 </div>
                 <div class="modal-footer">
                     <button type="button" id="btnSetPin" onclick="SetPin(this)" class="btn btn-primary font-weight-bold">Submit</button>
                 </div>
             </div>
         </div>
        </div>

        <div class="modal fade" id="changePinModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdrop" aria-hidden="true">
        <div class="modal-dialog modal-md" role="document">
            <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="changePinModalLabel">Change PIN</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <i aria-hidden="true" class="ki ki-close"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label text-lg-left">Enter Old PIN:</label>
                    <div class="col-sm-8">
                        <div class="input-group input-group-sm">
                            <input type="password" id="txtOldPin" class="form-control" placeholder="Pin" aria-describedby="basic-addon2" />
                            <div class="input-group-append">
                                <span class="input-group-text">
                                    <i class="la la-key"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label text-lg-left">Enter New PIN:</label>
                    <div class="col-sm-8">
                        <div class="input-group input-group-sm">
                            <input type="password" id="txtNewPin" class="form-control" placeholder="New PIN" aria-describedby="basic-addon2" />
                            <div class="input-group-append">
                                <span class="input-group-text">
                                    <i class="la la-key"></i>
                                </span>
                            </div>
                        </div>
                        <div class="bar"></div>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-4 col-form-label text-lg-left">Re-enter PIN:</label>
                    <div class="col-sm-8">
                        <div class="input-group input-group-sm">
                            <input type="password" id="txtREnPin" class="form-control" placeholder="Re-enter PIN" aria-describedby="basic-addon2" />
                            <div class="input-group-append">
                                <span class="input-group-text">
                                    <i class="la la-key"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="btnChangePin" onclick="ChangePin(this)" class="btn btn-primary font-weight-bold">Submit</button>
            </div>
        </div>
    </div>
</div>

    </form>
    <script src="assets/js/CreationMenu.js"></script>
    <!--end::Scrolltop-->
    <script>var KTAppSettings = { "breakpoints": { "sm": 576, "md": 768, "lg": 992, "xl": 1200, "xxl": 1400 }, "colors": { "theme": { "base": { "white": "#ffffff", "primary": "#3699FF", "secondary": "#E5EAEE", "success": "#1BC5BD", "info": "#8950FC", "warning": "#FFA800", "danger": "#F64E60", "light": "#E4E6EF", "dark": "#181C32" }, "light": { "white": "#ffffff", "primary": "#E1F0FF", "secondary": "#EBEDF3", "success": "#C9F7F5", "info": "#EEE5FF", "warning": "#FFF4DE", "danger": "#FFE2E5", "light": "#F3F6F9", "dark": "#D6D6E0" }, "inverse": { "white": "#ffffff", "primary": "#ffffff", "secondary": "#3F4254", "success": "#ffffff", "info": "#ffffff", "warning": "#ffffff", "danger": "#ffffff", "light": "#464E5F", "dark": "#ffffff" } }, "gray": { "gray-100": "#F3F6F9", "gray-200": "#EBEDF3", "gray-300": "#E4E6EF", "gray-400": "#D1D3E0", "gray-500": "#B5B5C3", "gray-600": "#7E8299", "gray-700": "#5E6278", "gray-800": "#3F4254", "gray-900": "#181C32" } }, "font-family": "Poppins" };</script>
    <!--end::Global Config-->
    <!--begin::Global Theme Bundle(used by all pages)-->
    <script src="assets/plugins/global/plugins.bundle.js"></script>
    <script src="assets/plugins/custom/prismjs/prismjs.bundle.js"></script>
    <script src="assets/js/scripts.bundle.js"></script>
    <script src="assets/js/select2.min.js"></script>
    <!--end::Global Theme Bundle-->
    <!--begin::Page Scripts(used by this page)-->
    <script src="assets/js/pages/widgets.js"></script>
    <!--end::Page Scripts-->

    <%--enjoyhint (tagaturo)--%>
    <script src="../Assets/enjoyhint/js/enjoyhint.js"></script>
    <script src="../Assets/enjoyhint/js/MainMenu.js"></script>
    <%--enjoyhint (tagaturo)--%>
    <script type="text/javascript" src="../js/DataTable/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="../js/DataTable/dataTables.bootstrap4.min.js"></script>
    <script src="../js/Notification_popup.js" type="text/javascript"></script>
    <script src="../js/disableIns.js"></script>
    <script>
        let Session = true;
        $(document).ready(function () {

            setInterval(function () {
                Notifjob(Session);
            }, 5000);

            var date = (new Date()).toISOString().split('T')[0];
            //document.getElementById("txtWorkDate").value = date;

            $.ajax({
                type: "POST",
                url: "GEARSMainMenu.aspx/getBookDate",
                data: '',
                dataType: "json",
                cache: false,
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    let objDetails = $.parseJSON(data.d);
                    document.getElementById("txtWorkDate").value = objDetails[0].Column1;
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                }
            });

            $('#selWarehouseCode').select2({
                /* set menu to display */
                width: '100%',
            });


            $('#txtNewPassword').keyup(function () {
                let pass_val = this.value;
                let strongRegex = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
                let mediumRegex = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
                let okRegex = new RegExp("(?=.{6,}).*", "g");

                if (okRegex.test(pass_val) === false) {
                    $('.bar').addClass('weak');
                } else if (strongRegex.test(pass_val)) {
                    $('.bar').addClass('strong');
                } else if (mediumRegex.test(pass_val)) {
                    $('.bar').addClass('medium');
                } else {
                    $('.bar').addClass('medium');
                }
            });
            $('#txtNewPassword').blur(function () {
                $('.bar').removeClass('medium');
                $('.bar').removeClass('weak');
                $('.bar').removeClass('strong');
            });

            $('body').on('click', '.menu-item', function () {
                if ($(this).children().length == 1) {
                    $('.menu-item-active').removeClass('menu-item-active');
                    $(this).addClass('menu-item-active');
                }
            });

            tour_checker();

            $('#btnPin').click(function () {
                // clean the input fields
                $('#txtSetPin').val('');
                $('#txtSetREnPin').val('');
                $('#txtOldPin').val('');
                $('#txtNewPin').val('');
                $('#txtREnPin').val('');
            })
        });

        function tour_checker() {

            var toursession = "<%=Session["TourDone"]%>";
            if (toursession == "0") {
                on();
                insertTour();
            }
        }

        function insertTour() {

            var tour = {};
            var useridsession = "<%=Session["userid"]%>";
            var moduleidsession = "<%=Session["ModuleID"]%>";
            var good = true;
            tour.UserID = useridsession;
            tour.ModuleID = moduleidsession;
            tour.DoNotShowTour = good;

            //$.ajax({
            //    type: "POST",
            //    url: "../Entity/AddData.aspx/InsertTour",
            //    data: '{ Tour:' + JSON.stringify(tour) + '}',
            //    dataType: "json",
            //    cache: false,
            //    contentType: "application/json; charset=utf-8",
            //    success: function (data) {
            //        //alert(data.d);
            //    },
            //    error: function (xhr, ajaxOptions, thrownError) {
            //        console.log(xhr.status);
            //        console.log(xhr.responseText);
            //        console.log(thrownError);
            //    }
            //});
        }

        function ChangePass(type) {
            if (document.getElementById("txtOldPassword").value != "" && (document.getElementById("txtNewPassword").value == document.getElementById("txtREnPassword").value)) {
                fetch("GEARSMainMenu.aspx/ChangePassword", {
                    method: "POST",
                    body: '{OldPass: "' + document.getElementById("txtOldPassword").value + '", NewPass: "' + document.getElementById("txtREnPassword").value + '"}',
                    headers: {
                        "Content-Type": "application/json;charset=utf-8"
                    }
                }).then(function (response) {
                    return response.json();
                }).then(function (data) {
                    alert(data.d);
                }).catch(function (error) {
                    console.log(error);
                });
            }
            else {
                alert("All fields are required!!!");
            }
        }
        
        function SetPin(type) {
            let pin = document.getElementById('txtSetPin').value;
            let confirmPin = document.getElementById('txtSetREnPin').value;

            fetch("GEARSMainMenu.aspx/SetPin", {
                method: "POST",
                body: '{Pin: "' + pin + '", ConfirmPin: "' + confirmPin +'"}',
                headers: {
                    "Content-Type": "application/json;charset=utf-8"
                }
            }).then(function (response) {
                return response.json();
            }).then(function (data) {
                alert(data.d);
                if (data.d == "PIN set successfully!") {
                    $('.close').click();
                    $("#btnPin").text("Change PIN");
                    $("#btnPin").attr("data-target", "#changePinModal");
                }
            }).catch(function (error) {
                console.log(error);
            });
        }

        function ChangePin(type) {
            let oldPin = document.getElementById('txtOldPin').value;
            let newPin = document.getElementById('txtNewPin').value;
            let reEnPin = document.getElementById('txtREnPin').value

            fetch("GEARSMainMenu.aspx/ChangePin", {
                method: "POST",
                body: '{OldPin: "' + oldPin + '", NewPin: "' + newPin + '", ReEnPin: "' + reEnPin + '"}',
                headers: {
                    "Content-Type": "application/json;charset=utf-8"
                }
            }).then(function (response) {
                return response.json();
            }).then(function (data) {
                alert(data.d);
                if (data.d == "PIN updated successfully!") {
                    $('.close').click();
                }
            }).catch(function (error) {
                console.log(error);
            });
        }


        function SetSession(type) {
            let SessionValue = (type == "submitwd" ? document.getElementById("txtWorkDate").value : document.getElementById("selWarehouseCode").value);
            fetch("GEARSMainMenu.aspx/SetSessionValue", {
                method: "POST",
                body: '{value: "' + SessionValue + '", type: "' + type + '"}',
                headers: {
                    "Content-Type": "application/json;charset=utf-8"
                }
            }).then(function (response) {
                return response.json();
            }).then(function (data) {
                alert(data.d);
            }).catch(function (error) {
                console.log(error);
            });
        }

        function Contracts() {
            $.ajax({
                type: "POST",
                url: "GEARSMainMenu.aspx/GetContract",
                dataType: "json",
                cache: false,
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    if (data.d[2] == "success") {
                        let datas = JSON.parse(data.d[1]);
                        (async () => {
                            await ConstTABLE(2, datas, 'Contracttable', 0, 'asc');
                        })();

                    }
                    else if (data.d[2] == "error") {
                        Swal.fire({
                            title: data.d[0],
                            text: data.d[1],
                            icon: data.d[2],
                            willClose: function () {
                                $('.scroll-box').fadeIn('fast');
                            }
                        });
                    }
                }
            });
        }

        function NotifyMe() {
            $.ajax({
                type: "POST",
                url: "GEARSMainMenu.aspx/GetNotify",
                dataType: "json",
                cache: false,
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    if (data.d[2] == "success") {
                        let datas = JSON.parse(data.d[1]);
                        (async () => {
                            await ConstTABLE(2, datas, 'Notificationtable', 0, 'asc');
                        })();
                    }
                    else if (data.d[2] == "error") {
                        Swal.fire({
                            title: data.d[0],
                            text: data.d[1],
                            icon: data.d[2],
                            willClose: function () {
                                $('.scroll-box').fadeIn('fast');
                            }
                        });
                    }
                }
            });
        }

        function GetDropdownEmp() {
            $.ajax({
                type: "POST",
                url: "GEARSMainMenu.aspx/getWareHouse",
                //data: '{Id: ' + JSON.stringify(id) + '}',
                data: '{Id: ' + null + '}',
                dataType: "json",
                cache: false,
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    let objDetails = $.parseJSON(data.d);
                    $.each(objDetails, function (i, item) {
                        $('<option value="' + item.WarehouseCode + '">' + item.Description + '- (' + item.WarehouseCode + ')' + '</option>').appendTo('#selWarehouseCode');
                    });
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    console.log(xhr.status);
                    console.log(xhr.responseText);
                    console.log(thrownError);
                }
            });
        }

        function ChangeName(value) {
            let className = value.className;
            document.getElementById("AbbrCompName_").innerHTML = className.includes("active") != true ? "GEARS" : "G";
        }

        function ChangeStyle() {
            let ValHeaderBase = document.getElementById("selHeaderBase").value,
                ValHeaderMenu = document.getElementById("selHeaderMenu").value,
                ValLayoutBrand = document.getElementById("selLayoutBrand").value,
                ValLayoutAside = document.getElementById("selLayoutAside").value

            document.getElementById("myHeaderBase").href = "assets/css/themes/layout/header/base/" + ValHeaderBase + ".css";
            document.getElementById("myHeaderMenu").href = "assets/css/themes/layout/header/menu/" + ValHeaderMenu + ".css";
            document.getElementById("myLayoutBrand").href = "assets/css/themes/layout/brand/" + ValLayoutBrand + ".css";
            document.getElementById("myLayoutAside").href = "assets/css/themes/layout/aside/" + ValLayoutAside + ".css";
        }


        function ResetStyle() {
            document.getElementById("myHeaderBase").href = "assets/css/themes/layout/header/base/dark.css";
            document.getElementById("myHeaderMenu").href = "assets/css/themes/layout/header/menu/dark.css";
            document.getElementById("myLayoutBrand").href = "assets/css/themes/layout/brand/dark.css";
            document.getElementById("myLayoutAside").href = "assets/css/themes/layout/aside/dasrk.css";
        }

        const setElementHeight = function () {
            var height = $(window).height();
            $("#MyFrame").css("min-height", height - 108);
        };
        $(window).on("resize", function () {
            setElementHeight();
        }).resize();

        var myVal = setInterval(checkSession, 2000);

        function checkSession() {

            $.ajax({
                type: "POST",
                url: "../checksession.aspx/check",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "isExpired") {
                        alert("User Session Expired. Please click Ok to refresh the window.");
                        window.location = "../Login/Login.aspx?mode=logout";
                        clearInterval(myVal);
                        Session = false;
                        return false;
                    } else if (result.d == "isUsed") {
                        alert("Another User Has Logged In This Account");
                        window.location = "../Login/Login.aspx?mode=logout";
                        clearInterval(myVal);
                        Session = false;
                        return false;
                    }
                    else {
                        Session = true;
                    }
                },
                error: function () {
                    window.location = "../Login/Login.aspx?mode=logout";
                    clearInterval(myVal);
                    return false;
                }
            });
        }


        $('#btnUpdateEmail').click(function () {
            console.log('clicked');
            if (document.getElementById("txtEmail").value != "" && document.getElementById("txtPassword").value != "" && document.getElementById("txtHost").value != "" && document.getElementById("txtPort").value != "") {
                fetch("GEARSMainMenu.aspx/UpdateEmail", {
                    method: "POST",
                    body: '{Email: "' + document.getElementById("txtEmail").value + '", Password: "' + document.getElementById("txtPassword").value + '", Host: "' + document.getElementById("txtHost").value + '", Port: "' + document.getElementById("txtPort").value + '"}',
                    headers: {
                        "Content-Type": "application/json;charset=utf-8"
                    }
                }).then(function (response) {
                    return response.json();
                }).then(function (data) {
                    var output = data.d;
                    if (output == "Update Success") {
                        Swal.fire("Success", output, "success");
                    }
                    else {
                        Swal.fire("Warning", output, "warning");
                    }
                }).catch(function (error) {
                    Swal.fire("Error!", "Something happened!", "error");
                });
            }
            else {
                alert("All fields are required!!!");
            }
        });

        $('#getEmail').click(function () {
            fetch("GEARSMainMenu.aspx/btnGetEmail_Click", {
                method: "POST",
                body: '{}',
                headers: {
                    "Content-Type": "application/json;charset=utf-8"
                }
            }).then(function (response) {
                return response.json();
            }).then(function (data) {
                var output = data.d;
                $('#txtEmail').val(output[0]);
                $('#txtPassword').val(output[1]);
                $('#txtHost').val(output[2]);
                $('#txtPort').val(output[3]);
            }).catch(function (error) {
                Swal.fire("Error!", "Something happened!", "error");
            });
        });

        $('#btnContact').click(function () {
            var loadurl = $(this).data('load-url');
            console.log(loadurl);
            $('#supportModal').find('.modal-body').load(loadurl, function (response, status, xhr) {
                if (status == "error") {
                    var msg = "Sorry but there was an error: ";
                    alert(msg + xhr.status + " " + xhr.statusText);
                }
            });
        });




    </script>

    <script type="text/javascript" src="https://assets.freshdesk.com/widget/freshwidget.js"></script>
    <script type="text/javascript">
        FreshWidget.init("", { "queryString": "&helpdesk_ticket[requester]=&helpdesk_ticket[subject]=&helpdesk_ticket[custom_field][phone_number]={{user.phone}}", "utf8": "✓", "widgetType": "popup", "buttonType": "text", "buttonText": "Support", "buttonColor": "white", "buttonBg": "#02b875", "alignment": "2", "offset": "85%", "formHeight": "500px", "url": "https://metsit.freshdesk.com" });

    </script>


    <%-- Custom JS --%>
</body>
</html>
