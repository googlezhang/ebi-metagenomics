package uk.ac.ebi.interpro.metagenomics.memi.springmvc.modelbuilder.results;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import uk.ac.ebi.interpro.metagenomics.memi.controller.MGPortalURLCollection;
import uk.ac.ebi.interpro.metagenomics.memi.core.MemiPropertyContainer;
import uk.ac.ebi.interpro.metagenomics.memi.core.tools.MemiTools;
import uk.ac.ebi.interpro.metagenomics.memi.forms.EBISearchForm;
import uk.ac.ebi.interpro.metagenomics.memi.model.Run;
import uk.ac.ebi.interpro.metagenomics.memi.model.hibernate.AnalysisJob;
import uk.ac.ebi.interpro.metagenomics.memi.services.FileExistenceChecker;
import uk.ac.ebi.interpro.metagenomics.memi.services.FileObjectBuilder;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.Breadcrumb;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.analysisPage.*;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.results.DownloadViewModel;
import uk.ac.ebi.interpro.metagenomics.memi.springmvc.session.UserManager;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Model builder class for {@link uk.ac.ebi.interpro.metagenomics.memi.springmvc.model.results.DownloadViewModel}.
 * <p>
 * See {@link uk.ac.ebi.interpro.metagenomics.memi.springmvc.modelbuilder.ViewModelBuilder} for more information of how to use.
 *
 * @author Maxim Scheremetjew, EMBL-EBI, InterPro
 * @since 1.4-SNAPSHOT
 */
public class DownloadViewModelBuilder extends AbstractResultViewModelBuilder<DownloadViewModel> {

    private final static Log log = LogFactory.getLog(DownloadViewModelBuilder.class);

    private Run run;

    private Map<String, DownloadableFileDefinition> fileDefinitionsMap;

    private Map<String, DownloadableFileDefinition> chunkedResultFilesMap;

    /*
    Contains a map of downloadable file lists for each pipeline version.
     */
    private Map<String, List> downloadableFileLists;


    public DownloadViewModelBuilder(UserManager sessionMgr,
                                    EBISearchForm ebiSearchForm,
                                    String pageTitle,
                                    List<Breadcrumb> breadcrumbs,
                                    MemiPropertyContainer propertyContainer,
                                    Run run,
                                    Map<String, DownloadableFileDefinition> fileDefinitionsMap,
                                    Map<String, DownloadableFileDefinition> chunkedResultFilesMap,
                                    Map<String, List> downloadableFileLists,
                                    AnalysisJob analysisJob) {
        super(sessionMgr, ebiSearchForm, pageTitle, breadcrumbs, propertyContainer, null, null, null, analysisJob);
        this.run = run;
        this.fileDefinitionsMap = fileDefinitionsMap;
        this.chunkedResultFilesMap = chunkedResultFilesMap;
        this.downloadableFileLists = downloadableFileLists;
    }

    public DownloadViewModel getModel() {
        log.info("Building instance of " + DownloadViewModel.class + "...");
        final DownloadSection downloadSection = buildDownloadSection(run, fileDefinitionsMap, analysisJob);
        return new DownloadViewModel(getSessionSubmitter(sessionMgr), getEbiSearchForm(), pageTitle, breadcrumbs, propertyContainer, downloadSection, analysisJob.getSample());
    }

    private DownloadSection buildDownloadSection(final Run run,
                                                 final Map<String, DownloadableFileDefinition> fileDefinitionsMap,
                                                 final AnalysisJob analysisJob) {
        // Get various necessary attributes like accessions and status
        final String externalSampleId = run.getExternalSampleId();
        final String externalProjectId = run.getExternalProjectId();
        final String externalRunId = run.getExternalRunId();
        final boolean sampleIsPublic = run.isPublic();
        final String analysisJobReleaseVersion = analysisJob.getPipelineRelease().getReleaseVersion();

        // Instantiate download links and sections
        final SequencesDownloadSection sequencesDownloadSection = new SequencesDownloadSection();
        final TaxonomyDownloadSection taxonomyDownloadSection = new TaxonomyDownloadSection();
        final List<DownloadLink> unchunkedSeqDataDownloadLinks = new ArrayList<DownloadLink>();
        final List<DownloadLink> otherFuncAnalysisDownloadLinks = new ArrayList<DownloadLink>();
        final List<DownloadLink> interproscanDownloadLinks = new ArrayList<DownloadLink>();

        // Build external link to ENA website
        final String linkURL = (sampleIsPublic ? "https://www.ebi.ac.uk/ena/data/view/" + externalRunId : "https://www.ebi.ac.uk/ena/submit/sra/#home");
        sequencesDownloadSection.addExternalDownloadLink(new DownloadLink("Submitted nucleotide reads",
                "Click to download all submitted nucleotide data on the ENA website",
                linkURL,
                true,
                1));

        // Set the list of downloadable files depending on the pipeline version
        // Those sets are defined in a Spring configuration file and injected in the controller
        List<String> downloadableFileList = null;
        if (analysisJobReleaseVersion.equals("1.0")) {
            downloadableFileList = downloadableFileLists.get("v1");
        } else if (analysisJobReleaseVersion.equalsIgnoreCase("2.0")) {
            downloadableFileList = downloadableFileLists.get("v2");
        } else if (analysisJobReleaseVersion.equalsIgnoreCase("3.0")) {
            downloadableFileList = downloadableFileLists.get("v3");
        } else {
            downloadableFileList = new ArrayList<String>();
        }

        // Iterate over the list of pre-defined downloadable files
        // Please note: Some downloadable files are chunked and compressed (e.g. all sequence files are chunked) and others not
        for (String downloadableFile : downloadableFileList) {
            // First check if there is a chunked version of this file
            DownloadableFileDefinition chunkedFileDefinition = chunkedResultFilesMap.get(downloadableFile);
            //If chunked and compressed
            if (chunkedFileDefinition != null) {
                File chunkedFileObject = FileObjectBuilder.createFileObject(analysisJob, propertyContainer, chunkedFileDefinition);
                boolean doesExist = FileExistenceChecker.checkFileExistence(chunkedFileObject);
                if (doesExist && chunkedFileObject.length() > 0) {
                    // Get result file chunks as a list of absolute file paths
                    List<String> chunkedResultFiles = MemiTools.getListOfChunkedResultFiles(chunkedFileObject);
                    // Loop through the list of chunked files and check if they do exist and are not empty
                    boolean checkResult = checkChunkedFilesDoExist(chunkedResultFiles, chunkedFileDefinition);
                    // Only further proceed if exists
                    if (checkResult) {
                        final List<DownloadLink> downloadLinks = new ArrayList<DownloadLink>();
                        //Processed reads are different between version 1 and 2
                        if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("MASKED_FASTA") || chunkedFileDefinition.getIdentifier().equalsIgnoreCase("PROCESSED_READS_FILE")) {
                            sequencesDownloadSection.setProcessedReadsLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("READS_WITH_PREDICTED_CDS_FILE")) {
                            sequencesDownloadSection.setReadsWithPredictedCDSLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("READS_WITH_MATCHES_FASTA_FILE")) {
                            sequencesDownloadSection.setReadsWithMatchesLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("READS_WITHOUT_MATCHES_FASTA_FILE")) {
                            sequencesDownloadSection.setReadsWithoutMatchesLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("PREDICTED_CDS_FILE")) {
                            sequencesDownloadSection.setPredictedCDSLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("PREDICTED_CDS_WITH_ANNOTATION_FILE")) {
                            sequencesDownloadSection.setPredictedCDSWithAnnotationLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("PREDICTED_CDS_WITHOUT_ANNOTATION_FILE")) {
                            sequencesDownloadSection.setPredictedCDSWithoutAnnotationLinks(downloadLinks);
                        } else if (chunkedFileDefinition.getIdentifier().equalsIgnoreCase("PREDICTED_ORF_WITHOUT_ANNOTATION_FILE")) {
                            sequencesDownloadSection.setPredictedORFWithoutAnnotationLinks(downloadLinks);
                        } else {
                            log.warn("Unknown file definition identifier: " + chunkedFileDefinition.getIdentifier() + " encountered!");
                        }

                        //We do need to distinguish 2 cases - case 1: single compressed file - case 2: chunked and compressed result files
                        //Case 1 will look like: InterPro matches (TSV) - 47 MB
                        //Case 2 will look like: InterPro matches (TSV, 3 parts): - Part 1 (500 MB) - Part 2 (499 MB)
                        String linkText = chunkedFileDefinition.getLinkText();

                        int chunkCounter = 1;
                        //Set link prefix including the nunmber of chunks, e.g.
                        //InterPro matches (TSV, 3 parts):
                        String numberOfChunks = chunkedResultFiles.size() + " parts";
                        for (String chunk : chunkedResultFiles) {
                            if (chunkedResultFiles.size() > 1) {
                                String partStr = " Part " + String.valueOf(chunkCounter);
                                linkText = partStr;
                            }
                            String relativePath = chunkedFileDefinition.getRelativePath();
                            if (relativePath != null) {
                                String fileParent = new File(relativePath).getParent();
                                chunk = fileParent + "/" + chunk;
                            }
                            final File downloadFileObj = FileObjectBuilder.createFileObject(analysisJob, propertyContainer, chunk);

                            String linkPrefix = chunkedFileDefinition.getLinkText();
                            String linkPreNumberOfChunks = numberOfChunks;
//                          String linkPrefix = chunkedFileDefinition.getLinkText().replace(")", ", " + numberOfChunks + ")");


                            if (chunkedFileDefinition instanceof SequenceFileDefinition) {
                                downloadLinks.add(new DownloadLink(linkText,
                                        chunkedFileDefinition.getLinkTitle(),
                                        "projects/" + externalProjectId + "/samples/" + externalSampleId + "/runs/" + externalRunId + "/results/versions/" + analysisJobReleaseVersion + "/sequences/"
                                                + chunkedFileDefinition.getLinkURL() + "/chunks/" + String.valueOf(chunkCounter),
                                        chunkedFileDefinition.getOrder(),
                                        getFileSize(downloadFileObj), linkPrefix, linkPreNumberOfChunks));

                            } else if (chunkedFileDefinition instanceof FunctionalAnalysisFileDefinition) {
                                //Filter out amplicons
                                if (!isAmpliconData()) {
                                    interproscanDownloadLinks.add(new DownloadLink(linkText,
                                            chunkedFileDefinition.getLinkTitle(),
                                            "projects/" + externalProjectId + "/samples/" + externalSampleId + "/runs/" + externalRunId + "/results/versions/" + analysisJobReleaseVersion + "/function/InterProScan/chunks/" + String.valueOf(chunkCounter),
                                            chunkedFileDefinition.getOrder(),
                                            getFileSize(downloadFileObj), linkPrefix, linkPreNumberOfChunks));
                                }
                            } else {
                                //do nothing
                            }
                            chunkCounter++;
                        }
                    } //end if chunked files existence check
                    else {
                        log.warn("One of the chunked files does not exist:");
                        log.warn(chunkedFileObject.getAbsolutePath());
                        log.warn("Will go on with the unchunked version.");
                        processUnchunkedFileDefinition(downloadableFile, analysisJobReleaseVersion, externalProjectId, externalSampleId, externalRunId,
                                unchunkedSeqDataDownloadLinks, otherFuncAnalysisDownloadLinks, taxonomyDownloadSection);
                    }
                } else {//Chunk summary file does not exist
                    log.warn("The following .chunks file does not exist:");
                    log.warn(chunkedFileObject.getAbsolutePath());
                    log.warn("Will go on with the unchunked version.");
                    processUnchunkedFileDefinition(downloadableFile, analysisJobReleaseVersion, externalProjectId, externalSampleId, externalRunId,
                            unchunkedSeqDataDownloadLinks, otherFuncAnalysisDownloadLinks, taxonomyDownloadSection);
                }
            } else {//No chunked version of this file
                processUnchunkedFileDefinition(downloadableFile, analysisJobReleaseVersion, externalProjectId, externalSampleId, externalRunId,
                        unchunkedSeqDataDownloadLinks, otherFuncAnalysisDownloadLinks, taxonomyDownloadSection);
            }

        }


        Collections.sort(unchunkedSeqDataDownloadLinks, DownloadLink.DownloadLinkComparator);
        sequencesDownloadSection.addUnchunkedDownloadLinks(unchunkedSeqDataDownloadLinks);
        Collections.sort(otherFuncAnalysisDownloadLinks, DownloadLink.DownloadLinkComparator);
        return new DownloadSection(
                sequencesDownloadSection,
                new FunctionalDownloadSection(interproscanDownloadLinks, otherFuncAnalysisDownloadLinks),
                taxonomyDownloadSection);
    }

    /**
     * Loops through the list of chunked files, creates file objects and checks if they do exist and are not empty.
     *
     * @return FALSE if at least 1 file does not exist or the list of chunked files is empty, otherwise TRUE.
     */
    private boolean checkChunkedFilesDoExist(final List<String> chunkedResultFiles,
                                             final DownloadableFileDefinition chunkedFileDefinition) {
        boolean result = (chunkedResultFiles.size() > 0 ? true : false);
        for (String chunk : chunkedResultFiles) {
            String relativePath = chunkedFileDefinition.getRelativePath();
            if (relativePath != null) {
                String fileParent = new File(relativePath).getParent();
                chunk = fileParent + "/" + chunk;
            }
            final File downloadFileObj = FileObjectBuilder.createFileObject(analysisJob, propertyContainer, chunk);
            if (!downloadFileObj.exists() || downloadFileObj.length() == 0) {
                return false;
            }
        }
        return result;
    }

    private void processUnchunkedFileDefinition(final String downloadableFile, final String analysisJobReleaseVersion,
                                                final String externalProjectId, final String externalSampleId, final String externalRunId,
                                                final List<DownloadLink> seqDataDownloadLinks, final List<DownloadLink> otherFuncAnalysisDownloadLinks,
                                                final TaxonomyDownloadSection taxonomyDownloadSection) {
        DownloadableFileDefinition fileDefinition = fileDefinitionsMap.get(downloadableFile);
        // Replace the asterix (*) in the relative path attribute of non coding RNA file definition by the input file name
        // e.g. /RNA-selector/*_tRNAselect.fasta
        String fileDefinitionId = fileDefinition.getIdentifier();
        //Create a clone and manipulate the new instance rather then the original
        DownloadableFileDefinition fileDefinitionClone = (DownloadableFileDefinition) fileDefinition.clone();
        if (fileDefinitionId != null && fileDefinitionClone.getIdentifier().equalsIgnoreCase("NC_RNA_T_RNA_FILE")) {
            String inputFileName = analysisJob.getInputFileName();
            String relativePath = fileDefinitionClone.getRelativePath();
            String newRelativePath = relativePath.replace("*", inputFileName);
            fileDefinitionClone.setRelativePath(newRelativePath);
        }

        File fileObject = FileObjectBuilder.createFileObject(analysisJob, propertyContainer, fileDefinitionClone);
        boolean doesExist = FileExistenceChecker.checkFileExistence(fileObject);
        if (doesExist && fileObject.length() > 0) {
            if (fileDefinitionClone instanceof SequenceFileDefinition) {
                //filter out certain files by release version
                if (fileDefinitionClone.getReleaseVersion() == null || fileDefinitionClone.getReleaseVersion().equals(analysisJobReleaseVersion)) {
                    seqDataDownloadLinks.add(new DownloadLink(fileDefinitionClone.getLinkText(),
                            fileDefinitionClone.getLinkTitle(),
                            "projects/" + externalProjectId + "/samples/" + externalSampleId + "/runs/" + externalRunId + "/results/versions/" + analysisJobReleaseVersion + "/sequences/" + fileDefinitionClone.getLinkURL(),
                            fileDefinitionClone.getOrder(),
                            getFileSize(fileObject)));
                }
            }// If taxonomy section downloadable file
            else if (fileDefinitionClone instanceof TaxonomicAnalysisFileDefinition) {
                String linkText = fileDefinitionClone.getLinkText();
                String linkTitle = fileDefinitionClone.getLinkTitle();
                String linkURL = MGPortalURLCollection.PROJECT_SAMPLE_RUN_RESULTS_TAXONOMY_TYPE
                        .replace("{projectId}", externalProjectId)
                        .replace("{sampleId}", externalSampleId)
                        .replace("{runId}", externalRunId)
                        .replace("{releaseVersion:\\d\\.\\d}", analysisJobReleaseVersion)
                        // TODO: Introduce new result type
                        .replace("{resultType}", fileDefinitionClone.getLinkURL());
                int order = fileDefinitionClone.getOrder();
                String fileSize = getFileSize(fileObject);
                DownloadLink taxonomyDownloadLink = new DownloadLink(linkText, linkTitle, linkURL, order, fileSize);
                taxonomyDownloadSection.addDownloadLink(taxonomyDownloadLink);
            } // If functional download section downloadable file
            else if (fileDefinitionClone instanceof FunctionalAnalysisFileDefinition) {
                //Filter out amplicons
                if (!isAmpliconData()) {
                    if (fileDefinitionClone.getIdentifier().equals("INTERPROSCAN_RESULT_FILE")) {
                        String filePath = fileObject.getAbsolutePath();
                        File newFileObject = new File(filePath + ".chunks");
                        if (!FileExistenceChecker.checkFileExistence(newFileObject)) {
                            otherFuncAnalysisDownloadLinks.add(new DownloadLink(fileDefinitionClone.getLinkText(),
                                    fileDefinitionClone.getLinkTitle(),
                                    "projects/" + externalProjectId + "/samples/" + externalSampleId + "/runs/" + externalRunId + "/results/" + fileDefinitionClone.getLinkURL() + "/versions/" + analysisJobReleaseVersion,
                                    fileDefinitionClone.getOrder(),
                                    getFileSize(fileObject)));
                        }
                    } else {
                        otherFuncAnalysisDownloadLinks.add(new DownloadLink(fileDefinitionClone.getLinkText(),
                                fileDefinitionClone.getLinkTitle(),
                                "projects/" + externalProjectId + "/samples/" + externalSampleId + "/runs/" + externalRunId + "/results/versions/" + analysisJobReleaseVersion + "/function/" + fileDefinitionClone.getLinkURL(),
                                fileDefinitionClone.getOrder(),
                                getFileSize(fileObject)));
                    }
                }
            } else {
                //do nothing
            }
        } else {
            log.warn("Download page warning: The following file does Not exist or is empty:");
            log.warn(fileObject.getAbsolutePath());
        }

    }

    private String getFileSize(final File file) {
        if (file.canRead()) {
            long fileLength = file.length();
            long cutoff = 1024 * 1024;
            //If file size is bigger than 1MB
            if (fileLength > cutoff) {
                long fileSize = fileLength / (long) (1024 * 1024);
                return fileSize + " MB";
            } else {
                //If file size is bigger than 1KB
                if (fileLength > 1024) {
                    long fileSize = fileLength / (long) 1024;
                    return fileSize + " KB";
                } else {
                    return fileLength + " bytes";
                }
            }
        }
        return "";
    }
}