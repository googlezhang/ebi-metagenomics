package uk.ac.ebi.interpro.metagenomics.memi.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import uk.ac.ebi.interpro.metagenomics.memi.dao.RunDAO;
import uk.ac.ebi.interpro.metagenomics.memi.dao.erapro.SubmissionContactDAO;
import uk.ac.ebi.interpro.metagenomics.memi.dao.hibernate.BiomeDAO;
import uk.ac.ebi.interpro.metagenomics.memi.dao.hibernate.SampleDAO;
import uk.ac.ebi.interpro.metagenomics.memi.dao.hibernate.StudyDAO;
import uk.ac.ebi.interpro.metagenomics.memi.model.hibernate.SecureEntity;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.Breadcrumb;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.HomePageViewModel;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.ViewModel;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.modelbuilder.HomePageViewModelBuilder;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.modelbuilder.ViewModelBuilder;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents the controller for the MG portal home page.
 *
 * @author Maxim Scheremetjew, EMBL-EBI, InterPro
 * @since 1.0-SNAPSHOT
 */
@Controller(value = "homePageController")
@RequestMapping(value = "/")
public class HomePageController extends AbstractController implements IController {

    private final Log log = LogFactory.getLog(HomePageController.class);

    /**
     * View name of this controller which is used several times.
     */
    public static final String VIEW_NAME = "index";

    public static final String REQUEST_MAPPING_VALUE = "";

    public static final String REDIRECT_VALUE = "/" + REQUEST_MAPPING_VALUE;

    //Data access objects
    @Resource
    private StudyDAO studyDAO;

    @Resource
    private SampleDAO sampleDAO;

    @Resource
    private RunDAO runDAO;

    @Resource
    private BiomeDAO biomeDAO;

    @Resource
    private SubmissionContactDAO submissionContactDAO;

    @Override
    public ModelAndView doGet(ModelMap model) {
        log.info("Requesting doGet of " + this.getClass());

        return buildModelAndView(
                getModelViewName(),
                model,
                new ModelPopulator() {
                    @Override
                    public void populateModel(ModelMap model) {
                        log.info("Building model of " + HomePageController.class + "...");
                        final ViewModelBuilder<HomePageViewModel> builder = new HomePageViewModelBuilder(
                                userManager,
                                getEbiSearchForm(),
                                "EBI metagenomics: archiving, analysis and integration of metagenomics data",
                                getBreadcrumbs(null), propertyContainer, studyDAO, sampleDAO, runDAO, biomeDAO, submissionContactDAO);
                        final HomePageViewModel hpModel = builder.getModel();
                        hpModel.changeToHighlightedClass(ViewModel.TAB_CLASS_HOME_VIEW);
                        model.addAttribute(ViewModel.MODEL_ATTR_NAME, hpModel);
                    }
                }
        );
    }

    protected String getModelViewName() {
        return VIEW_NAME;
    }

    protected List<Breadcrumb> getBreadcrumbs(SecureEntity entity) {
        return new ArrayList<Breadcrumb>();
    }
}