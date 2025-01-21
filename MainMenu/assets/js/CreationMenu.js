"use strict";

CreationSideMenu();

function CreationSideMenu() {
    fetch("GEARSMainMenu.aspx/GetData", {
        method: "POST",
        body: '{}',
        headers: {
            "Content-Type": "application/json;charset=utf-8"
        }
    }).then(function (response) {
        return response.json();
    }).then(function (data) {
     
        let objectData = JSON.parse(data.d);
        let root = makeTree(objectData);
        document.getElementById("kt_aside_menu").innerHTML = BuildTreeList(root, false, 1);
        Init();
    }).catch(function (error) {
        console.log(error);
    });
}

function BuildTreeList(data, isSub, root) {
    let search = '<div class="input-group" style="padding: 0 20px;"> '
               + '     <input type="password" autocomplete="new-password" style="visibility: hidden; position: absolute; top: -10000px" /> ' //TO DISABLE AUTO FILL
               + '        <input type="text" id="search" class="form-control menu-search" placeholder="Search..." autocomplete="off"> '
               + '        <span class="input-group-btn icon-search p-0" style="height: calc(1.5em + 1.3rem + 2px)"> '
               + '                <a href="javascript:;" class="btn btn-icon pulse pulse-primary submit p-0"> '
               + '                    <span class="svg-icon svg-icon-primary svg-icon-2x"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1"> '
               + '                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"> '
               + '                            <rect x="0" y="0" width="24" height="24"></rect> '
               + '                            <path d="M14.2928932,16.7071068 C13.9023689,16.3165825 13.9023689,15.6834175 14.2928932,15.2928932 C14.6834175,14.9023689 15.3165825,14.9023689 15.7071068,15.2928932 L19.7071068,19.2928932 C20.0976311,19.6834175 20.0976311,20.3165825 19.7071068,20.7071068 C19.3165825,21.0976311 18.6834175,21.0976311 18.2928932,20.7071068 L14.2928932,16.7071068 Z" fill="#000000" fill-rule="nonzero" opacity="0.3"></path> '
               + '                            <path d="M11,16 C13.7614237,16 16,13.7614237 16,11 C16,8.23857625 13.7614237,6 11,6 C8.23857625,6 6,8.23857625 6,11 C6,13.7614237 8.23857625,16 11,16 Z M11,18 C7.13400675,18 4,14.8659932 4,11 C4,7.13400675 7.13400675,4 11,4 C14.8659932,4 18,7.13400675 18,11 C18,14.8659932 14.8659932,18 11,18 Z" fill="#000000" fill-rule="nonzero"></path> '
               + '                    </g> '
               + '                    </svg></span> '
               + '                <span class="pulse-ring p-0"></span> '
               + '                </a> '
               + '        </span> '
               + '</div> ';
    let sub_href = '<a class="menu-link menu-toggle" href="FILEPATH" target="iframe_a"> ' + ' ICON ' + ' <span class="menu-text">PROMPT</span> ' + ' <i class="menu-arrow"></i> ' + '</a>';
    let no_sub_href = '<a href="FILEPATH" target="iframe_a" class="menu-link"> ' + ' ICON ' + ' <span class="menu-text">PROMPT</span> ' + '</a> ';
    let html = root == 1 ? '<ul class="menu-nav">' + search + '' : '';

    html += isSub ? '<div class="menu-submenu"> <i class="menu-arrow"></i> <ul class="menu-subnav">' : '';
    data.forEach(function (item) {
        html += isSub ? '<li class="menu-item menu-item-submenu" aria-haspopup="true" data-menu-toggle="hover">' : '<li class="menu-item" aria-haspopup="true">';
        let ICON = root ? '                    <span class="svg-icon menu-icon"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1"> '
               + '                    <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"> '

               + '' + item.Icon + ''
               + '                    </g> '
               + '                    </svg></span> '
             : '<i class="menu-bullet menu-bullet-dot"><span></span></i>';

        if (item.sub) {
            if (isSub) {
                html += sub_href.replace(/PROMPT/g, '' + item.Prompt + '').replace(/ICON/g, '' + ICON + '').replace(/FILEPATH/g, '' + item.FilePath + '');
            } else {
                html += sub_href.replace(/PROMPT/g, '' + item.Prompt + '').replace(/ICON/g, '' + ICON + '').replace(/FILEPATH/g, '' + item.FilePath + '');
            }
            html += BuildTreeList(item.sub, true, 0);
        } else {
            html += no_sub_href.replace(/ICON/g, '' + ICON + '').replace(/PROMPT/g, '' + item.Prompt + '').replace(/FILEPATH/g, '' + item.FilePath + '');
        }

        html += '</li>';
    });

    html += isSub ? '</ul></div>' : '';
    html += root == 1 ? '</ul>' : '';

    return html;
}

function makeTree(items) {
    return items.filter(function (item) {
        var p = this.get(item.pid);
        if (p) p.sub = (p.sub || []).concat(item);
        return !p;
    }, new Map(items.map(function (c) {
        return [c.id, c];
    })));
}

function Init() {
    $("#search").on("keyup", function () {
        if (this.value.length > 0) {
            $("li").hide().filter(function () {
                console.log($(this).text().toLowerCase().indexOf($("#search").val().toLowerCase()));
                return $(this).text().toLowerCase().indexOf($("#search").val().toLowerCase()) != -1;
            }).show();
            $('li').removeClass('menu-item-open');
            $("li").addClass('menu-item-open');
        }
        else {
            $('li').removeClass('menu-item-open');
            $("li").show();
        }
    });
}