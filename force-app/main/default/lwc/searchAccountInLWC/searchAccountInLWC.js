import { LightningElement } from 'lwc';

import fetchAccounts from '@salesforce/apex/SearchAccountController.fetchAccounts';
import { NavigationMixin } from 'lightning/navigation';
 
const columns = [ 
    { label: 'Name', fieldName: 'Name' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Rating', fieldName: 'Rating' },
    { label: 'View Action',type: "button", typeAttributes: {
        label: 'View',
        name: 'view',
        title: 'View',
        value: 'view',
        iconPosition: 'center'
    } },
    { label: 'Edit Action', type: "button", typeAttributes: {
        label: 'Edit',
        name: 'edit',
        title: 'Edit',
        value: 'edit',
        iconPosition: 'center',
        variant:"brand"
    } }
];

export default class SearchAccountInLWC extends NavigationMixin( LightningElement ) {
    accounts;
    error;
    columns = columns;
    
    handleKeyChange( event ) {
        const searchKey = event.target.value;
        if ( searchKey ) {
            fetchAccounts({ searchKey })
            .then(result => {
                this.accounts = result;
            })
            .catch(error => {
                this.error = error;
            });
        } else
        this.accounts = undefined;
    }
    handleRowAction( event ) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch ( actionName ) {
           
            case 'view':
                this[ NavigationMixin.Navigate ]( {
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'Account',
                        actionName: 'view'
                    }
                } );
                break;
           
                case 'edit':
                this[ NavigationMixin.Navigate ]( {
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'Account',
                        actionName: 'edit'
                    }
                });
                break;
            default:
        }
    }
}