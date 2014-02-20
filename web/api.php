<?php

include 'config.php';

$ret = array();
try {
    $ret['status'] = array();
    if (!isset($_REQUEST['method'])) {
        throw new Exception("Method is not found", 404);
    } else {
        $method = $_REQUEST['method'];
        switch ($method) {
            case 'getInstances' :
                $ret['results'] = R::findAndExport('instance');
                break;
            case 'addInstances':
                $instance = R::dispense('instance');
                $instance->import($_REQUEST['data']);
                R::store($instance);
                break;
            case "deployToInstance":
                $instance = isset($_REQUEST['instance']) ? $_REQUEST['instance'] : "";
                if (!$instance)
                    throw new Exception("Instance not found", 406);
            case "deploy":
                $instance  = isset($instance)? $instance : "";
                if ($_FILES["file"]["error"] > 0) {
                    throw new Exception("Error uploading the file", 400);
                }
                $ret['results'] = exec("../scripts.sh deploy {$_FILES['file']['tmp_name']} $instance");
                break;
            case "createInstance":

                break;
            default:
                throw new Exception("Method not allowed $method", 405);
                break;
        }
        $ret['status']['type'] = 'success';
        $ret['status']['code'] = 200;
    }
} catch (Exception $exc) {
    $ret['status'] = array('type' => 'error', 'code' => $exc->getCode(), 'message' => $exc->getMessage());
}
header('X-PHP-Response-Code:', true, $ret['status']['code']);
//http_response_code($ret['status']['code']);
echo json_encode($ret);
?>

