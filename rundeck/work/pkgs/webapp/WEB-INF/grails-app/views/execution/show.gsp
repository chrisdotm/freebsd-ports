<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="tabpage" content="jobs"/>
    <meta name="layout" content="base" />
    <title><g:message code="main.app.name"/> - <g:if test="${null==execution?.dateCompleted}">Now Running - </g:if><g:if test="${scheduledExecution}">${scheduledExecution?.jobName.encodeAsHTML()} :  </g:if><g:else>Transient <g:message code="domain.ScheduledExecution.title"/> : </g:else> Execution at <g:relativeDate atDate="${execution.dateStarted}" /> by ${execution.user}</title>
    <g:set var="followmode" value="${params.mode in ['browse','tail','node']?params.mode:null==execution?.dateCompleted?'tail':'browse'}"/>
    <g:set var="executionResource" value="${ ['jobName': execution.scheduledExecution ? execution.scheduledExecution.jobName : 'adhoc', 'groupPath': execution.scheduledExecution ? execution.scheduledExecution.groupPath : 'adhoc'] }"/>

      <g:javascript library="executionControl"/>
      <g:javascript library="prototype/effects"/>
      <g:javascript>
        <g:if test="${scheduledExecution}">
        /** START history
         *
         */
        function loadHistory(){
            new Ajax.Updater('histcontent',"${createLink(controller:'reports',action:'eventsFragment')}",{
                parameters:{compact:true,nofilters:true,jobIdFilter:'${scheduledExecution.id}'},
                evalScripts:true,
                onComplete: function(transport) {
                    if (transport.request.success()) {
                        Element.show('histcontent');
                    }
                }
            });
        }
        </g:if>
        var followControl = new FollowControl('${execution?.id}','commandPerform',{
            appLinks:appLinks,
            iconUrl: "${resource(dir: 'images', file: 'icon')}",
            extraParams:"<%="true" == params.disableMarkdown ? '&disableMarkdown=true' : ''%>",
            lastlines: ${params.lastlines ? params.lastlines : 20},

            tailmode: ${followmode == 'tail'},
            browsemode: ${followmode == 'browse'},
            nodemode: ${followmode == 'node'},
            execData: {node:"${session.Framework.getFrameworkNodeHostname()}"},
            <auth:allowed job="${executionResource}" name="${UserAuth.WF_KILL}">
            killjobhtml: '<span class="action button textbtn" onclick="followControl.docancel();">Kill <g:message code="domain.ScheduledExecution.title"/> <img src="${resource(dir: 'images', file: 'icon-tiny-removex.png')}" alt="Kill" width="12px" height="12px"/></span>',
            </auth:allowed>
            <auth:allowed job="${executionResource}" name="${UserAuth.WF_KILL}" has="false">
            killjobhtml: "",
            </auth:allowed>
            totalDuration : 0 + ${scheduledExecution?.totalTime ? scheduledExecution.totalTime : -1},
            totalCount: 0 + ${scheduledExecution?.execCount ? scheduledExecution.execCount : -1}
            <g:if test="${scheduledExecution}">
            , onComplete:loadHistory
            </g:if>
        });


        function init() {
            followControl.beginFollowingOutput('${execution?.id}');
            $$('.obs_bubblepopup').each(function(e) {
                new BubbleController(e,null,{offx:-14,offy:null}).startObserving();
            });
        }

        Event.observe(window, 'load', init);

      </g:javascript>
      <style type="text/css">

        #log{
            margin-bottom:20px;
        }
      </style>
  </head>

  <body>
    <div class="pageTop extra">
        <div class="jobHead">
            <g:render template="/scheduledExecution/showHead" model="[scheduledExecution:scheduledExecution,execution:execution,followparams:[mode:followmode,lastlines:params.lastlines]]"/>
        </div>
        <div class="clear"></div>
    </div>
    <div class="pageBody">

        <table>
            <tr>
                <td>

        <table class="executionInfo">
            <tr>
                <td>User:</td>
                <td>${execution?.user}</td>
            </tr>
            <g:if test="${null!=execution.dateCompleted && null!=execution.dateStarted}">

                <tr>
                    <td>Time:</td>
                    <td><g:relativeDate start="${execution.dateStarted}" end="${execution.dateCompleted}" /></td>
                </tr>
            </g:if>
            <g:if test="${null!=execution.dateStarted}">
            <tr>
                <td>Started:</td>
                <td>
                    <g:relativeDate elapsed="${execution.dateStarted}" agoClass="timeago"/>
                </td>
                <td><span class="timeabs">${execution.dateStarted}</span></td>
            </tr>
            </g:if>
            <g:else>
                <td>Started:</td>
                <td>Just Now</td>
            </g:else>

        <g:if test="${null!=execution.dateCompleted}">
                <tr>
                    <td>Finished:</td>
                    <td>
                        <g:relativeDate elapsed="${execution.dateCompleted}" agoClass="timeago"/>
                    </td>
                    <td><span class="timeabs">${execution.dateCompleted}</span></td>
                </tr>
            </g:if>
        </table>

                </td>
                <g:if test="${scheduledExecution}">
                    <td style="vertical-align:top;" class="toolbar small">
                        <g:render template="/scheduledExecution/actionButtons" model="${[scheduledExecution:scheduledExecution,objexists:objexists,jobAuthorized:jobAuthorized,execPage:true]}"/>
                        <g:set var="lastrun" value="${scheduledExecution.id?Execution.findByScheduledExecutionAndDateCompletedIsNotNull(scheduledExecution,[max: 1, sort:'dateStarted', order:'desc']):null}"/>
                        <g:set var="successcount" value="${scheduledExecution.id?Execution.countByScheduledExecutionAndStatus(scheduledExecution,'true'):0}"/>
                        <g:set var="execCount" value="${scheduledExecution.id?Execution.countByScheduledExecution(scheduledExecution):0}"/>
                        <g:set var="successrate" value="${execCount>0? (successcount/execCount) : 0}"/>
                        <g:render template="/scheduledExecution/showStats" model="[scheduledExecution:scheduledExecution,lastrun:lastrun?lastrun:null, successrate:successrate]"/>
                    </td>
                </g:if>
            </tr>
        </table>

        <g:expander key="schedExDetails${scheduledExecution?.id?scheduledExecution?.id:''}" imgfirst="true">Details</g:expander>
        <div class="presentation" style="display:none" id="schedExDetails${scheduledExecution?.id}">
            <g:render template="execDetails" model="[execdata:execution]"/>

        </div>
    </div>


    <div id="commandFlow" class="commandFlow">
        <table width="100%">
            <tr>
                <td width="50%">

        <g:if test="${null!=execution.dateCompleted}">

                    Status:
                    <span class="${execution.status=='true'?'succeed':'fail'}" >
                        <g:if test="${execution.status=='true'}">
                            Successful
                        </g:if>
                        <g:elseif test="${execution.cancelled}">
                            Killed<g:if test="${execution.abortedby}"> by: ${execution.abortedby.encodeAsHTML()}</g:if>
                        </g:elseif>
                        <g:else>
                            Failed
                        </g:else>
                    </span>
            </g:if>
            <g:else>
                    Status:

                        <span id="runstatus">
                        <span class="nowrunning">
                        <img src="${resource(dir:'images',file:'icon-tiny-disclosure-waiting.gif')}" alt="Spinner"/>
                        Now Running&hellip;
                        </span>
                        </span>
                    <auth:allowed job="${executionResource}" name="${UserAuth.WF_KILL}">
                        <span id="cancelresult" style="margin-left:10px">
                            <span class="action button textbtn" onclick="followControl.docancel();">Kill <g:message code="domain.ScheduledExecution.title"/> <img src="${resource(dir:'images',file:'icon-tiny-removex.png')}" alt="Kill" width="12px" height="12px"/></span>
                        </span>
                    </auth:allowed>

            </g:else>

                    <span id="execRetry" style="${wdgt.styleVisible(if:null!=execution.dateCompleted && null!=execution.failedNodeList)}; margin-right:10px;">
                        <g:if test="${scheduledExecution}">
                            <g:set var="jobRunAuth" value="${ auth.allowedTest(job:executionResource,action:UserAuth.WF_RUN)}"/>
                            <g:set var="canRun" value="${ ( !authMap || authMap[scheduledExecution.id.toString()] ||jobAuthorized ) && jobRunAuth}"/>
                            <g:if test="${ canRun}">
                                <g:link controller="scheduledExecution" action="execute" id="${scheduledExecution.id}" params="${[retryFailedExecId:execution.id]}" title="Run Job on the failed nodes" class="action button" style="margin-left:10px" >
                                    <img src="${resource(dir:'images',file:'icon-small-run.png')}" alt="run" width="16px" height="16px"/>
                                    Retry Failed Nodes  &hellip;
                                </g:link>
                            </g:if>
                        </g:if>
                        <g:else>
                            <g:set var="jobRunAuth" value="${ auth.allowedTest(job:executionResource,action:[UserAuth.WF_CREATE,UserAuth.WF_READ])}"/>
                            <g:set var="canRun" value="${ jobRunAuth}"/>
                            <g:if test="${canRun}">
                                <g:link controller="scheduledExecution" action="createFromExecution" params="${[executionId:execution.id,failedNodes:true]}" class="action button" title="Retry on the failed nodes&hellip;" style="margin-left:10px">
                                    <img src="${resource(dir:'images',file:'icon-small-run.png')}"  alt="run" width="16px" height="16px"/>
                                    Retry Failed Nodes &hellip;
                                </g:link>
                            </g:if>
                        </g:else>
                    </span>
                    <span id="execRerun" style="${wdgt.styleVisible(if:null!=execution.dateCompleted)}" >
                        <g:set var="jobRunAuth" value="${ auth.allowedTest(job:executionResource, action:[UserAuth.WF_CREATE,UserAuth.WF_READ])}"/>
                        <g:if test="${jobRunAuth }">
                            <g:link controller="scheduledExecution" action="createFromExecution" params="${[executionId:execution.id]}" class="action button" title="Rerun or Save this Execution&hellip;" ><img src="${resource(dir:'images',file:'icon-small-run.png')}"  alt="run" width="16px" height="16px"/> Rerun or Save &hellip;</g:link>
                        </g:if>
                    </span>
                </td>
                <td width="50%" >
                    <div id="progressContainer" class="progressContainer" >
                        <div class="progressBar" id="progressBar" title="Progress is an estimate based on average execution time for this ${g.message(code:'domain.ScheduledExecution.title')}.">0%</div>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div id="commandPerformOpts" class="outputdisplayopts" style="margin: 0 20px;">
        <form action="#" id="outputappendform">

        <table width="100%">
            <tr>
                <td class="buttonholder" style="padding:10px;">
                    <g:link class="tab ${followmode=='tail'?' selected':''}" style="padding:5px;"
                        title="${g.message(code:'execution.show.mode.Tail.desc')}"
                        controller="execution"  action="show" id="${execution.id}" params="${[lastlines:params.lastlines,mode:'tail'].findAll{it.value}}"><g:message code="execution.show.mode.Tail.title" default="Tail Output"/></g:link>
                    <g:link class="tab ${followmode=='browse'?' selected':''}" style="padding:5px;"
                        title="${g.message(code:'execution.show.mode.Annotated.desc')}"
                        controller="execution"  action="show" id="${execution.id}" params="[mode:'browse']"><g:message code="execution.show.mode.Annotated.title" default="Annotated"/></g:link>
                    <g:link class="tab ${followmode=='node'?' selected':''}" style="padding:5px;"
                        title="${g.message(code:'execution.show.mode.Compact.desc')}"
                        controller="execution"  action="show" id="${execution.id}" params="[mode:'node']"><g:message code="execution.show.mode.Compact.title" default="Compact"/></g:link>
                    
            <span id="fullviewopts" style="${followmode!='browse'?'display:none':''}">
                    <input
                        type="radio"
                        name="outputappend"
                        id="outputappendtop"
                        value="top"
                        style="display: none;"/>
                    <label for="outputappendtop">
                        <span
                        class="action textbtn button"
                        title="Click to change"
                            id="appendTopLabel"
                        onclick="followControl.setOutputAppendTop(true);"
                        >Top</span></label>
                    <input
                        type="radio"
                        name="outputappend"
                        id="outputappendbottom"
                        value="bottom"
                        checked="CHECKED"
                        style="display: none;"/>
                    <label
                        for="outputappendbottom">
                        <span
                            class="action textbtn button"
                            title="Click to change"
                            id="appendBottomLabel"
                            onclick="followControl.setOutputAppendTop(false);"
                        >Bottom</span></label>
<%--
            </td>
            <td>--%>
                <span class="action textbtn button"
                      title="Click to change"
                      id="ctxshowgroupoption"
                      onclick="followControl.setGroupOutput($('ctxshowgroup').checked);">
                <input
                    type="checkbox"
                    name="ctxshowgroup"
                    id="ctxshowgroup"
                    value="true"
                    ${followmode=='tail'?'':'checked="CHECKED"'}
                    style=""/>
                    <label for="ctxshowgroup">Group commands</label>
                </span>
<%--
                </td>

            <td >--%>
                &nbsp;
                <span
                    class="action textbtn button"
                    title="Click to change"
                    id="ctxcollapseLabel"
                    onclick="followControl.setCollapseCtx($('ctxcollapse').checked);">
                <input
                    type="checkbox"
                    name="ctxcollapse"
                    id="ctxcollapse"
                    value="true"
                    ${followmode=='tail'?'':null==execution?.dateCompleted?'checked="CHECKED"':''}
                    style=""/>
                    <label for="ctxcollapse">Collapse</label>
                </span>
<%--
            </td>
            <td>--%>
                &nbsp;
                <span class="action textbtn button"
                      title="Click to change"
                      id="ctxshowlastlineoption"
                      onclick="followControl.setShowFinalLine($('ctxshowlastline').checked);">
                <input
                    type="checkbox"
                    name="ctxshowlastline"
                    id="ctxshowlastline"
                    value="true"
                    checked="CHECKED"
                    style=""/>
                    <label for="ctxshowlastline">Show final line</label>
                </span>
            </span>
            <g:if test="${followmode=='tail'}">
<%---
                </td>
                <td>--%>
                    Show the last
                    <span class="action textbtn button"
                      title="Click to reduce"
                      onmousedown="followControl.modifyLastlines(-5);return false;">-</span>
                <input
                    type="text"
                    name="lastlines"
                    id="lastlinesvalue"
                    value="${params.lastlines?params.lastlines:20}"
                    size="3"
                    onchange="updateLastlines(this.value)"
                    onkeypress="var x= noenter();if(!x){this.blur();};return x;"
                    style=""/>
                    <span class="action textbtn button"
                      title="Click to increase"
                      onmousedown="followControl.modifyLastlines(5);return false;">+</span>

                    lines<span id="taildelaycontrol" style="${execution.dateCompleted?'display:none':''}">,
                    and update every


                    <span class="action textbtn button"
                      title="Click to reduce"
                      onmousedown="followControl.modifyTaildelay(-1);return false;">-</span>
                <input
                    type="text"
                    name="taildelay"
                    id="taildelayvalue"
                    value="1"
                    size="2"
                    onchange="updateTaildelay(this.value)"
                    onkeypress="var x= noenter();if(!x){this.blur();};return x;"
                    style=""/>
                    <span class="action textbtn button"
                      title="Click to increase"
                      onmousedown="followControl.modifyTaildelay(1);return false;">+</span>

                    seconds
                </span>
            </g:if>
                </td>
                <td align="right">
                    <span style="${execution.dateCompleted ? '' : 'display:none'}" class="sepL" id="viewoptionscomplete">
                        <g:link class="action txtbtn" style="padding:5px;"
                            title="Download entire output file" 
                            controller="execution" action="downloadOutput" id="${execution.id}"><img src="${resource(dir:'images',file:'icon-small-file.png')}" alt="Download" title="Download output" width="13px" height="16px"/> Download <span id="outfilesize">${filesize?filesize+' bytes':''}</span></g:link>
                    </span>
                </td>
            </tr>
            </table>
        </form>
    </div>
    <div id="fileload2" style="display:none;" class="outputdisplayopts"><img src="${resource(dir:'images',file:'icon-tiny-disclosure-waiting.gif')}" alt="Spinner"/> Loading Output... <span id="fileloadpercent"></span></div>
    <div
        id="commandPerform"
        style="display:none; margin: 0 20px; "></div>
    <div id="fileload" style="display:none;" class="outputdisplayopts"><img src="${resource(dir:'images',file:'icon-tiny-disclosure-waiting.gif')}" alt="Spinner"/> Loading Output... <span id="fileload2percent"></span></div>
    <div id="log"></div>
    <g:if test="${scheduledExecution}">
        <div class="runbox">History</div>
        <div class="pageBody">
            <div id="histcontent"></div>
            <g:javascript>
                fireWhenReady('histcontent',loadHistory);
            </g:javascript>
        </div>
    </g:if>
  </body>
</html>


