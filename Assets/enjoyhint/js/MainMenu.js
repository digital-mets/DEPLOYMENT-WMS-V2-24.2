function on() {
    document.getElementById("overlay").style.display = "block";
}

function off() {
    document.getElementById("overlay").style.display = "none";
    tagaturo();
}



function tagaturo() {
    console.log("tagaturo");
    //initialize instance
    var enjoyhint_instance = new EnjoyHint({
        onStart: function () { },
        onEnd: function () { }
    });

    //simple config. 
    //Only one step - highlighting(with description) "New" button 
    //hide EnjoyHint after a click on the button.
    var enjoyhint_script_steps = [

        {
            'next #MyFrame': 'You can navigate dashboard here.',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': false,

            onBeforeStart: function () {
             
                setTimeout(function () {
                    document.getElementById("enjoyhint_label").style.marginTop = "-400px";
                   
                }, 1000);
            }
           
        }, 
      {
            'next #kt_aside_menu_wrapper': 'You can navigate modules here',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': true,
            'shape': 'rectangle'

        },

        {
            'next #search': 'You can search your desire transaction',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': true,
            'shape': 'circle'

        }, 
         {
             'click #kt_quick_user_toggle': 'Click to view your Account Information here',
             'nextButton': { className: "myNext", text: "Got it" },
             'showSkip': false
            , 'shape': 'square'

        }, 
         
        {
            'next #kt_quick_user': 'This is your Account Information',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': true
            , 'shape': 'square'

        },
        {
            'next #Button1': 'Sign out here',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': true
            , 'shape': 'square'

        },
        {
            'click #kt_quick_user_close': 'Close the menu here',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': false
            , 'shape': 'square'

        },
        {
            'click #kt_quick_panel_toggle': 'Click to view themes',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': false
            , 'shape': 'square'

        }, 
         {
            'next #kt_quick_panel': 'You can change the apperance of the system here',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': true
            , 'shape': 'square'

        },
        {
            'click #kt_quick_panel_close': 'Close the menu here',
            'nextButton': { className: "myNext", text: "Got it" },
            'showSkip': false
            , 'shape': 'square'

        },

    ];

    //set script config
    enjoyhint_instance.set(enjoyhint_script_steps);

    //run Enjoyhint script
    enjoyhint_instance.run();


}