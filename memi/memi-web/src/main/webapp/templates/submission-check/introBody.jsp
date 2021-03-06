<%--
  Created by IntelliJ IDEA.
  User: maxim
  Date: 6/18/15
  Time: 4:13 PM
  To change this template use File | Settings | File Templates.
--%>
<!-- Add fancyBox -->


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>



<h2>Submit data</h2>
<!-- Related links -->
<!-- if video available -->
<!--<div class="sidebar-allrel">
        <div id="sidebar-video">
                       <iframe width="100%" height="180" src="https://www.youtube.com/embed/Zml8jTqfQPg" frameborder="0" allowfullscreen></iframe>

        </div>
    </div>  -->
<div class="sidebar-allrel">
    <div id="sidebar-related" class="sidebar-rel-help">
    <h2><span data-icon="?" class="icon icon-generic"></span> Need more support?</h2>
    <p>If you need more information about the submission process, you can either look at the:</p>
    <ul>
        <li>
          <a title="Click to view an online training - Step by step guide to submission" href="https://www.ebi.ac.uk/training/online/course/ebi-metagenomics-portal-quick-tour/submitting-data-ebi-metagenomics-portal"
                                                        class="list_more">Training material: Step by step guide to submission</a>
              <!--<span class="icon icon-generic" data-icon="T"></span>  -->
      </li>
    <li>
            <a title="ENA guide to Submitting environmental samples" href="https://www.ebi.ac.uk/ena/submit/environmental-submissions"
                                                          class="list_more">Submitting environmental samples</a>
        </li>
    <li>
        <a title="ENA sample checklists: MIxS data standard..." href="https://www.ebi.ac.uk/ena/submit/checklists"
                                                      class="list_more">Sample checklists: MIxS data standard...</a>
    </li>

    </ul>
        <p>or <a href="http://www.ebi.ac.uk/support/metagenomics">contact us</a> directly with your question. </p>
    </div>
    </div>
    <!--/ Related links -->
<p class="intro">
    We provide a free service for submission of raw metagenomics sequence data and associated metadata to the European
    Nucleotide Archive (ENA) and analysis by EBI Metagenomics.
</p>

<div class=" registration-check">
<!-- Remove new user button when already logged in -->
<c:if test="${empty model.submitter}">
    <div class="box-registration">
        <a href="<c:url value="${baseURL}/registration"/>" title="New user - start the submission"
           class="box-registration-link">
            <div class="box-registration-cont anim box-ban sq_button">
                <h3><span class="icon icon-functional" data-icon="7"></span> New user</h3>
            </div>
        </a>
    </div>
</c:if>

    <div class="box-registration">
        <a href="<c:url value="${baseURL}/registration/account-check"/>" title="Existing user"
           class="box-registration-link" id="test">
            <div class="box-registration-cont anim box-blue sq_button">
                <h3><span class="icon icon-functional" data-icon="/"></span> Existing user</h3>
            </div>
        </a>
    </div>

</div>
<p>
    If you have data that you wish to have analysed, you need an <strong>ENA submitter account</strong> that
    has been registered with EBI Metagenomics. This allows us to track your submitted data and ensures that we have
    consent to access it for analysis.
</p>

<p>With a valid ENA submitter account, you can submit your data directly using the <a class="ext"
                                                                                      title="Click here to submit data to ENA"
                                                                                      href="https://www.ebi.ac.uk/ena/submit/sra/#home">ENA
    Webin tool</a>, which will help you describe your metadata and upload your sequence data.</p>


<p>Once your reads are uploaded to the ENA, the EBI Metagenomics team will access them and perform the
    analysis, which is done in several steps. You will receive an email once the analysis starts and another when the
    analysis of all samples is complete (<a class="fancybox" rel="group"
                                            href="<c:url value="${baseURL}/img/graphic_submission_00.gif"/>"
                                            title="Detail of the submission and analysis process on the EBI metagneomics website">view
        figure for more details</a> of the submission and analysis process). The analysis time is dependent on the
    number of samples submitted and requests
    by other submitters at the time. If your samples are private, you will need to log in to the EBI Metagenomics
    homepage to be able to view the results of the analysis.
</p>

<script type="text/javascript">
    $(document).ready(function () {
        //TEMP - TO DELETE IF WE DON'T USE POPUP
        $('#registrationBlockUI').click(function () {
            $.blockUI({ message:$('#registration_dialog_div'), baseZ:100000, overlayCSS:{ backgroundColor:'#000', opacity:0.6, cursor:'pointer'}, css:{top:'25%', left:'25%', width:'517px', padding:'0px', border:'1px #AAA solid', 'border-radius':'12px', backgroundColor:'#C9C9C9' }});
            $('.blockOverlay').click($.unblockUI);
            $('#login_form').trigger("reset");
            return false;
        });//end click event

        //Click on close cross icon
        $(".close_window_button").click(function () {
            $.unblockUI();
            return false;
        });//end cancel click
    });
    // Script for the image zooming
    $(".fancybox").fancybox();

</script>