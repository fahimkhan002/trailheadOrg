import { LightningElement, track } from 'lwc';
import retriveNews from "@salesforce/apex/RetriveNewsController.retriveAllNews";

export default class NewsComponent extends LightningElement {
    @track result;
    @track selectedNews = {};
    @track isModalOpen = false;

    get modalOpen(){
        return this.isModalOpen?"slds-modal slds-fade-in-open":"slds-modal"
        // return `slds-modal ${this.isModalOpen ? "slds-fade-in-open":""}` this is also one way to do this.
    }
    get modalBlackDropClass(){
        return this.isModalOpen?"slds-backdrop slds-backdrop_open":"slds-backdrop"
    }

    connectedCallback(){
        this.fetchNews();
    }

    fetchNews(){
        retriveNews().then(response =>
        {
            console.log(response);
            this.formatNewsData(response.articles);
        }).catch(error =>{
            console.error(error);
        })
    }

    formatNewsData(res){
        this.result = res.map((item,index)=>{
            let id = `new_${index+1}`;
            console.log('ID ',id);
            let date = new Date(item.publishedAt).toDateString();
            let name = item.source.name;
            return {...item,id:id,name:name,date:date}
        })
    }

    showModal(event){
        let id = event.target.dataset.item;
        this.result.forEach(item =>{
            if(item.id === id){
                this.selectedNews = {...item};
            }
        })
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
    }



}