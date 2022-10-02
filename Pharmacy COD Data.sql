select s.orderid                                        [OrderId],
       s.shipmentTag                                    [SipmentTag],
       cast(dbo.tobdt(o.CreatedOnUtc)as smalldatetime)  [CreatedOn],
       cast(dbo.tobdt(s.reconciledon) as smalldatetime) [Reconciledon],
       sum(tr.saleprice)                                [Ordervalue],
       dbo.GetEnumName('ShipmentStatus',ShipmentStatus) [ShipmentStatus],
       s.deliveryFee                                    [DeliveryFee]

from Shipment s
join thingrequest tr on tr.shipmentid=s.id
join [order] o on o.id=s.OrderId
join store st on st.id = o.storeId
join ProductVariant pv on pv.id = tr.ProductVariantId
where s.ReconciledOn is not null
and pv.distributionNetworkId = 2
and s.ShipmentStatus not in (1,9,10)
and tr.IsReturned=0
and tr.IsCancelled=0
and tr.HasFailedBeforeDispatch=0
and tr.IsMissingAfterDispatch=0

group by  s.orderid,
          s.shipmentTag,
          st.name,
          cast(dbo.tobdt(o.CreatedOnUtc)as smalldatetime),
          cast(dbo.tobdt(s.reconciledon) as smalldatetime),
          dbo.GetEnumName('ShipmentStatus',ShipmentStatus),
          s.deliveryFee 
