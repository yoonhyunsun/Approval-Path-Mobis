import getQuipPdfUrl from "@salesforce/apex/QuipController.getQuipPdfUrl";
import tryQuipPdfUrl from "@salesforce/apex/QuipController.tryQuipPdfUrl";

export const requestQuipPdf = async (opportunityId, reportType) => {
  const obj = { url: undefined, error: undefined };

  try {
    const response = await getQuipPdfUrl({
      opportunityId,
      reportType: reportType
    });

    console.log(response);

    if (response.exportPdfStatus === "SUCCESS" || response.quipPdfUrl) {
      console.log("Success");
      obj.url = response.quipPdfUrl;
      return obj;
    }

    if (response?.error) {
      console.log("ERROR");
      obj.error = response.error;
      return obj;
    }

    let counter = 72; //amout of attempts to get quip url

    // eslint-disable-next-line @lwc/lwc/no-async-operation

    const promise = new Promise((resolve, reject) => {
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      let interval = setInterval(async () => {
        try {
          const tryQuipPdfUrlRespone = await tryQuipPdfUrl({
            quipDto: response,
            opportunityId
          });

          console.log(tryQuipPdfUrlRespone);

          if (counter === 0) {
            obj.error = tryQuipPdfUrlRespone.error ?? "error in time";
            clearInterval(interval);
            resolve(obj);
          }
          counter--;

          if (tryQuipPdfUrlRespone.exportPdfStatus === "SUCCESS") {
            obj.url = tryQuipPdfUrlRespone.quipPdfUrl;
            clearInterval(interval);
            resolve(obj);
          }
          if (
            tryQuipPdfUrlRespone.exportPdfStatus === "PARTIAL_SUCCESS" ||
            tryQuipPdfUrlRespone.exportPdfStatus === "FAILURE"
          ) {
            obj.error =
              "Quip PDF could not be exported. Status: " +
              tryQuipPdfUrlRespone.exportPdfStatus +
              ". Please try again later.";
            clearInterval(interval);
            resolve(obj);
          }
        } catch (e) {
          console.log(e);
          obj.error = e.message;
          clearInterval(interval);
          resolve(obj);
        }
      }, 10000);
    });

    const promiseResponse = await promise;

    return promiseResponse;
  } catch (err) {
    console.log("err");
    obj.error = err.body.message;
  }

  return obj;
};