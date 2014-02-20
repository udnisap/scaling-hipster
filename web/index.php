<?php include './header.php'; ?>
<!-- Right side column. Contains the navbar and content of the page -->
<aside class="right-side">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            Instances
            <small>Select an instance to view it's status</small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
            <li class="active">Instances</li>
        </ol>
    </section>
    <!-- Main content -->
    <section class="content">

        <!-- Small boxes (Stat box) -->
        <div class="row">
            <div class="col-lg-3 col-xs-6">
                <!-- small box -->
                <div class="small-box bg-aqua">
                    <div class="inner">
                        <h3>
                            1
                        </h3>
                        <p>
                            New Instance
                        </p>
                    </div>
                    <div class="icon">
                        <i class="ion ion-bag"></i>
                    </div>
                    <a href="#" class="small-box-footer">
                        More info <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div><!-- ./col -->
            <div class="col-lg-3 col-xs-6">
                <!-- small box -->
                <div class="small-box bg-green">
                    <div class="inner">
                        <h3>
                            53<sup style="font-size: 20px">%</sup>
                        </h3>
                        <p>
                            Completed
                        </p>
                    </div>
                    <div class="icon">
                        <i class="fa fa-trophy"></i>
                    </div>
                    <a href="#" class="small-box-footer">
                        More info <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div><!-- ./col -->
            <div class="col-lg-3 col-xs-6">
                <!-- small box -->
                <div class="small-box bg-yellow">
                    <div class="inner">
                        <h3>
                            4
                        </h3>
                        <p>
                            Instances
                        </p>
                    </div>
                    <div class="icon">
                        <i class="ion ion-android-display"></i>
                    </div>
                    <a href="#" class="small-box-footer">
                        More info <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div><!-- ./col -->
            <div class="col-lg-3 col-xs-6">
                <!-- small box -->
                <div class="small-box bg-red">
                    <div class="inner">
                        <h3>
                            5
                        </h3>
                        <p>
                            Jobs
                        </p>
                    </div>
                    <div class="icon">
                        <i class="ion ion-android-data"></i>
                    </div>
                    <a href="#" class="small-box-footer">
                        More info <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div><!-- ./col -->
        </div><!-- /.row -->

        <div class="row">
            <div class="col-xs-6">
                <div class="box box-success">
                    <div class="box-header">
                        <i class="fa fa-anchor"></i>
                        <h3 class="box-title">Your instances</h3>
                        <div class="box-tools pull-right">
                            <button class="btn" data-toggle="modal" data-target="#addInstance"><i class="fa fa-plus"> </i> Add</button>
                        </div>
                    </div><!-- /.box-header -->
                    <div class="box-body no-padding">
                        <table class="table">
                            <tr>
                                <th style="width: 10px">#</th>
                                <th>Server</th>
                                <th>Provider</th>
                                <th>Owner</th>
                                <th style="width: 40px">Status</th>
                            </tr>
                            <!-- ko foreach:instances -->
                            <tr data-bind="click:$root.onClick">
                                <td data-bind='text:($index()+1)+"."'></td>
                                <td data-bind="text:name"></td>
                                <td data-bind='text:provider'></td>
                                <td data-bind='text:owner'>perera.pasindu@gmail.com</td>
                                <td><span class="badge bg-green" data-bind='text:status'></span></td>
                            </tr>
                            <!-- /ko -->
                        </table>
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div>
            <div class="col-md-6" data-bind='if:activeInstance.name'>
                <div class="box box-info">
                    <div class="box-header">
                        <i class="fa fa-bullhorn"></i>
                        <h3 class="box-title">Status <small data-bind='text:name'></small></h3>
                    </div><!-- /.box-header -->
                    <div class="box-body" data-bind=" with:activeInstance">
                        <div class="row">
                            <div class="col-xs-1">
                                <img data-bind="attr:{src:'assets/providers/'+provider()+'.jpg'}" style="max-width: 100px" class="img-rounded"/>
                            </div>
                            <div class="col-xs-9">
                                <dl class="dl-horizontal">
                                    <dt>Name</dt>
                                    <dd data-bind='text:name'></dd>
                                    <dt>URL</dt>
                                    <dd><a href='#' data-bind='attr:{href:"http://"+url()} , text:url'></a></dd>
                                    <dt>Provider</dt>
                                    <dd data-bind='text:provider'></dd>
                                </dl>
                                <div class="btn-group pull-right">
                                    <button class="btn btn-success" data-toggle="modal" data-target="#addJob">Add Job</button>
                                    <button class="btn btn-danger">Stop</button>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class='row'>
                            <div class="col-xs-6 text-center" style="border-right: 1px solid #f4f4f4">
                                <input type="text" class="knob" data-bind='value:cpu' value="60" data-width="60" data-height="60" data-fgColor="#f56954"/>
                                <div class="knob-label">CPU</div>
                            </div><!-- ./col -->
                            <div class="col-xs-6 text-center" style="border-right: 1px solid #f4f4f4">
                                <input type="text" class="knob" data-readonly="true" data-bind='value:memory' value="80" data-width="60" data-height="60" data-fgColor="#00a65a"/>
                                <div class="knob-label">Memory</div>
                            </div><!-- ./col -->
                        </div>

                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div><!-- /.col -->
        </div>

    </section><!-- /.content -->
</aside><!-- /.right-side -->

<div id="addJob" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="myModalLabel">Add Job</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" method="post" _lpchecked="1">
                    <fieldset>
                        <div class="control-group">
                            <label class="control-label" for="name">Script file</label>
                            <div class="controls form-group">
                                <div class="col-sm-8">
                                    <textarea cols="20" rows="20" id="script"></textarea>
                                    <input type="file" id="file" class="form-control" placeholder="uploadfile">
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">close</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" data-bind="click:addJob">Add</button>
            </div>
        </div>
    </div>
</div>

<div id="addInstance" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="myModalLabel">Add Job</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" method="post" _lpchecked="1">
                    <fieldset>
                        <div class="control-group">
                            <label class="control-label" for="name">Name</label>
                            <div class="controls form-group">
                                <div class="col-sm-8">
                                    <input type="text" id="name" class="form-control" placeholder="Name of the group">
                                </div>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">Hash</label>
                            <div class="controls form-group">
                                <div class="col-sm-8">
                                    <input type="text" id="hash" class="form-control" placeholder="Name of the group">
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">close</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" data-bind="click:addInstance">Add</button>
            </div>
        </div>
    </div>
</div>
<?php include './footer.php'; ?>