var VM = function() {
    var instances = ko.observableArray([]),
            jobs = ko.observableArray([]);
    var load = function(data, success, error) {
        $.ajax({
            data: data
        }).done(function(data) {
            success(data.results);
        }).error(function(data) {
            error(data);
        });
    }

    var activeInstance = {
        name: ko.observable(""),
        url: ko.observable(""),
        provider: ko.observable("heroku"),
        memory: ko.observable("20"),
        cpu: ko.observable("50"),
        status: ko.observable("live")
    };



    var click = function(item) {
        activeInstance.name(item.name);
        activeInstance.url(item.url);
        activeInstance.provider(item.provider);
        activeInstance.memory(item.memory);
        activeInstance.cpu(item.cpu);
    };

    var getJob = function() {
        load({method: "getJobs"}, function(data) {
            jobs.removeAll();
            $.each(data, function(i, o) {
                jobs.push(o);
            })
        });
    };

    var addJob = function() {
        var script = $('#script').val()
        console.log(script);
        load({method: "addJob", script: script}, function(data) {
            
        });
    };

    var updateInstances = function() {
        load({method: "getInstances"}, function(data) {
            instances.removeAll();
            $.each(data, function(i, o) {
                instances.push(o);
            })
        })
    };


    $.ajaxSetup({
        url: "api.php",
        type: "POST",
        dataType: "json"
    });
    $(".knob").knob();
    updateInstances();

    return {
        jobs : jobs,
        addJob: addJob,
        instances: instances,
        update: updateInstances,
        onClick: click,
        activeInstance: activeInstance
    }
}();

$(function() {
    ko.applyBindings(VM);
})